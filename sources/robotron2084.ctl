; Copyright Atarisoft (UK) 1984, 2025 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
> $4000 @expand=#DEF(#POKE()(a) #LINK(Pokes#$a))
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Robotron: 2084 Loading Screen. } { #SCR$02(loading) } UDGTABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

g $6100

g $8000 Print State: Y Position
@ $8000 label=PrintState_Y
  $8000,$01 Current Y (vertical) pixel position.

g $8001 Print State: X Position
@ $8001 label=PrintState_X
  $8001,$01 Current X (horizontal) pixel position.

g $8002 Print State: Bit-Shift Count
@ $8002 label=PrintState_BitShift
  $8002,$01 Sub-byte bit-shift count for the character currently being rendered.

g $8003 Print State: Character Code
@ $8003 label=PrintState_Char
  $8003,$01 Character code of the glyph currently being rendered.

g $8004 Print State: Attribute Byte
@ $8004 label=PrintState_Attr
  $8004,$01 Current attribute byte (INK, PAPER, BRIGHT and FLASH).

g $8005 Print State: Left Margin
@ $8005 label=PrintState_LeftMargin
  $8005,$01 Left margin X position; X resets here on a carriage return.

g $8006 Print State: Right Margin
@ $8006 label=PrintState_RightMargin
  $8006,$01 Right margin X position; a line wrap occurs when X would exceed this.

g $8007 Print State: Flags
@ $8007 label=PrintState_Flags
  $8007,$01 Flags; bit 0 = control code parameter was out of range.

g $8008 Print State: Font Bitmap Pointer
@ $8008 label=PrintState_FontPtr
W $8008,$02
  $8008,$02 Font bitmap data pointer; base address for character glyph lookups.

g $800A Print State: Handler Pointer
@ $800A label=PrintState_Handler
W $800A,$02
  $800A,$02 Current byte handler; pointer into the print state machine (default #R$8DE3).

g $800C Print State: Normal Width
@ $800C label=PrintState_Width
  $800C,$01 Normal character pixel width.

g $800D Print State: Narrow Width
@ $800D label=PrintState_NarrowWidth
  $800D,$01 Narrow character pixel width (used for "#CHR$49").

g $800E Print State: Wide Width
@ $800E label=PrintState_WideWidth
  $800E,$01 Wide character pixel width (used for "#CHR$4D" and "#CHR$57").

g $800F Print State: Space Width
@ $800F label=PrintState_SpaceWidth
  $800F,$01 Space character pixel width.

g $8010 Print State: Line Height
@ $8010 label=PrintState_LineHeight
  $8010,$01 Font line height in pixels; Y advances by this on a carriage return.

g $8011 Print State: Row Count
@ $8011 label=PrintState_RowCount
  $8011,$01 Number of pixel rows per character glyph.

b $8100 Font UDGs
@ $8100 label=Font
  $8100,$08 #UDG(#PC,attr=56)
L $8100,$08,$5E

c $8D80

c $8DCC Print Dispatch
@ $8DCC label=PrintDispatch
  $8DCC,$01 Stash #REGbc on the stack.
  $8DCD,$01 Switch to the shadow registers.
  $8DCE,$03 Stash #REGhl and #REGix on the stack.
  $8DD1,$04 #REGix=#R$8000.
  $8DD5,$03 #REGhl=#R$8DDD.
  $8DD8,$01 Stash #REGhl on the stack.
  $8DD9,$03 #REGhl=*#R$800A.
  $8DDC,$01 Jump to *#REGhl.

  $8DDD,$03 Restore #REGix and #REGhl from the stack.
  $8DE0,$01 Switch back to the normal registers.
  $8DE1,$01 Restore #REGbc from the stack.
  $8DE2,$01 Return.

c $8DE3 Print Handler
@ $8DE3 label=PrintHandler
D $8DE3 The default print handler for the state machine pointer at #R$800A. Called on
. initialisation, and restored after each byte is consumed. Dispatches each byte of
. a messaging string to the appropriate action based on its value:
.
. #TABLE(default,centre,centre)
. { =h Byte | =h Action }
. { #N$20–#N$7F | Print the ASCII character. }
. { #N$80–#N$FF | Replace with #N$21 ("#CHR$21") and print. }
. { #N$0D | Carriage return: reset X to left margin, advance Y by one line. }
. { #N$10–#N$1A | Control code: install a parameter handler into #R$800A. }
. { All others | Replace with #N$3F ("#CHR$3F") and print. }
. TABLE#
R $8DE3 A Byte to print or control code
  $8DE3,$04 If the byte is less than #N$80, jump to #R$8DEC.
  $8DE7,$02 Otherwise replace the byte with #N$21 ("#CHR$21").
  $8DE9,$03 Jump to #R$8EF7 to render the character.
N $8DEC Dispatch handler for printing.
@ $8DEC label=PrintHandler_Dispatch
  $8DEC,$05 If the byte is #N$20 or higher (printable ASCII), jump to #R$8EF7 to render it.
  $8DF1,$04 If the byte is a carriage return (#N$0D), jump to #R$8E0F.
  $8DF5,$04 If the byte is less than #N$10, jump to #R$8E29 (unsupported code).
  $8DF9,$04 If the byte is #N$1B or higher, jump to #R$8E29 (unsupported code).
N $8DFD Look up the two-byte handler address from the control code dispatch table at
. #R$8FD0. The code is zero-indexed from #N$10 and doubled since each table entry is
. two bytes wide.
  $8DFD,$03 #REGhl=#R$8FD0 (base of the control code dispatch table).
  $8E00,$02 Zero-index the control code from #N$10.
  $8E02,$03 #REGde=zero-indexed control code.
  $8E05,$02 Double the index (two bytes per table entry).
  $8E07,$03 Read the handler address from the dispatch table into #REGde.
  $8E0A,$04 Write the handler address to #R$800A.
  $8E0E,$01 Return.
@ $8E0F label=PrintHandler_Newline
N $8E0F Carriage return handler: resets the X position to the left margin, then advances
. the Y position by one font line height (wrapping at #N$BC).
  $8E0F,$03 #REGhl=#R$8001 (X position pointer).
  $8E12,$03 #REGa=*#R$8005 (left margin X position).
  $8E15,$01 Write the left margin value to *#REGhl, resetting X to the left margin.
  $8E16,$01 Decrement #REGhl to point at #R$8000 (Y position).
@ $8E17 label=PrintHandler_AdvanceRow
  $8E17,$04 #REGa=*#REGhl + font line height (*#R$8010).
  $8E1B,$04 Wrap the Y position at #N$BC if it has reached or exceeded that value.
  $8E1F,$02 Subtract #N$BC to wrap Y.
@ $8E21 label=PrintHandler_AdvanceRow_Store
  $8E21,$01 Write the new Y position back to *#REGhl.
  $8E22,$01 Return.
@ $8E23 label=PrintHandler_Unsupported
N $8E23 Parameter handler for unsupported control codes #N$14 and #N$15. Consumes the
. parameter byte by resetting #R$800A to the default handler, then falls through to
. #R$8E29 to print a "#CHR$3F" (#N$3F) placeholder.
  $8E23,$06 Reset #R$800A to #R$8DE3 (default handler).
@ $8E29 label=PrintHandler_Invalid
  $8E29,$02 Replace the byte with #N$3F ("#CHR$3F").
  $8E2B,$03 Jump to #R$8EF7 to render the character.
@ $8E2E label=PrintHandler_Ink
N $8E2E Set INK colour parameter handler. Called on the byte immediately following a
. #N$10 (INK) control code. Masks the parameter to the lower three bits (colour
. #N$00–#N$07) and writes it into the INK bits (0–2) of the attribute byte at
. #R$8004.
  $8E2E,$02 #REGb=#N$08 (mask limit for INK colour range #N$00–#N$07).
  $8E30,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to the colour value.
  $8E33,$03 #REGa=*#R$8004 (current attribute byte).
  $8E36,$02,b$01 Clear the INK bits (#N$F8 = keep PAPER, BRIGHT, FLASH).
  $8E38,$01 Write the new INK colour into bits 0–2.
  $8E39,$03 Write the updated attribute byte back to *#R$8004.
  $8E3C,$01 Return.
@ $8E3D label=PrintHandler_Paper
N $8E3D Set PAPER colour parameter handler. Called on the byte immediately following a
. #N$11 (PAPER) control code. Masks the parameter to the lower three bits (colour
. #N$00–#N$07) and writes it into the PAPER bits (3–5) of the attribute byte at
. #R$8004.
  $8E3D,$02 #REGb=#N$08 (mask limit for PAPER colour range #N$00–#N$07).
  $8E3F,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to the colour value.
  $8E42,$03 #REGa=*#R$8004 (current attribute byte).
  $8E45,$02,b$01 Clear the PAPER bits (#N$C7 = keep INK, BRIGHT, FLASH).
  $8E47,$06 Shift #REGb left three positions to move the colour into bits 3–5.
  $8E4D,$01 Write the new PAPER colour into bits 3–5.
  $8E4E,$03 Write the updated attribute byte back to *#R$8004.
  $8E51,$01 Return.
@ $8E52 label=PrintHandler_Flash
N $8E52 Set FLASH parameter handler. Called on the byte immediately following a #N$12
. (FLASH) control code. Sets or clears bit 7 of the attribute byte at #R$8004.
  $8E52,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E54,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E57,$02 Test bit 0 of the masked parameter.
  $8E59,$02 If the parameter is #N$00, jump to #R$8E60 to clear FLASH.
  $8E5B,$04 Set the FLASH bit (7) of the attribute byte at #R$8004.
  $8E5F,$01 Return.
@ $8E60 label=PrintHandler_Flash_Off
  $8E60,$04 Clear the FLASH bit (7) of the attribute byte at #N$8004.
  $8E64,$01 Return.
@ $8E65 label=PrintHandler_Bright
N $8E65 Set BRIGHT parameter handler. Called on the byte immediately following a #N$13
. (BRIGHT) control code. Sets or clears bit 6 of the attribute byte at #N$8004.
  $8E65,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E67,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E6A,$02 Test bit 0 of the masked parameter.
  $8E6C,$02 If the parameter is #N$00, jump to #R$8E73 to clear BRIGHT.
  $8E6E,$04 Set the BRIGHT bit (6) of the attribute byte at #N$8004.
  $8E72,$01 Return.
@ $8E73 label=PrintHandler_Bright_Off
  $8E73,$04 Clear the BRIGHT bit (6) of the attribute byte at #N$8004.
  $8E77,$01 Return.
@ $8E78 label=PrintHandler_PrintAt_X
N $8E78 PRINT AT first parameter handler. Called on the byte immediately following a
. #N$16 (PRINT AT) control code. Stores the X (column) parameter to #N$8001 and
. installs #R$8E82 into #R$800A to handle the next byte (the Y position).
  $8E78,$03 Write the X column parameter to *#R$8001.
  $8E7B,$03 #REGhl=#R$8E82 (Y position parameter handler).
  $8E7E,$03 Write #R$8E82 to #R$800A to consume the next (Y) byte.
  $8E81,$01 Return.
@ $8E82 label=PrintHandler_PrintAt_Y
N $8E82 PRINT AT second parameter handler. Called on the byte immediately following the
. X parameter. Wraps the Y (row) parameter at #N$BC and stores it to #N$8000 before
. restoring the default handler.
  $8E82,$06 Reset #R$800A to #R$8DE3 (default handler).
  $8E88,$04 If the Y parameter is less than #N$BC, jump to #R$8E8E.
  $8E8C,$02 Subtract #N$BC to wrap the Y position.
@ $8E8E label=PrintHandler_PrintAt_Y_Store
  $8E8E,$03 Write the Y position to *#R$8000.
  $8E91,$01 Return.
@ $8E92 label=PrintHandler_Tab
N $8E92 TAB parameter handler. Called on the byte immediately following a #N$17 (TAB)
. control code. Sets the X position (#N$8001) to the parameter value. If the
. parameter is less than the current X position (i.e., the cursor would move left),
. the Y position advances to the next row.
  $8E92,$06 Reset #R$800A to #R$8DE3 (default handler).
  $8E98,$01 #REGc=target X position (the TAB parameter).
  $8E99,$04 #REGb=*#R$8001 (current X position).
  $8E9D,$04 #REGa=target X; write target X to *#R$8001.
  $8EA1,$01 #REGa=target X − current X.
  $8EA2,$01 Return if the cursor moved right or stayed (no row advance needed).
  $8EA3,$03 #REGhl=#N$8000 (Y position pointer).
  $8EA6,$03 Call #R$8E17 to advance the Y position by one line.
  $8EA9,$01 Return.
@ $8EAA label=PrintHandler_LeftMargin
N $8EAA Left margin parameter handler. Called on the byte immediately following a #N$18
. control code. Sets the left margin X position at #N$8005 to the lower six bits of
. the parameter.
  $8EAA,$02 #REGb=#N$40 (mask limit: lower six bits, #N$00–#N$3F).
  $8EAC,$03 Call #R$8EE6 to reset #R$800A and mask #REGa to the lower six bits.
  $8EAF,$03 Write the masked parameter to *#R$8005 (left margin X position).
  $8EB2,$01 Return.
@ $8EB3 label=PrintHandler_RightMargin
N $8EB3 Right margin parameter handler. Called on the byte immediately following a #N$19
. control code. Stores the right margin X position to #N$8006. If the parameter is
. less than #N$80, a wrap flag is set in #N$8007 and #N$80 is OR'd into the value
. before storing.
  $8EB3,$06 Reset #R$800A to #R$8DE3 (default handler).
  $8EB9,$04 If the parameter is #N$80 or higher, jump to #R$8EC3 to store it directly.
  $8EBD,$04 Set the wrap flag (bit 0 of *#N$8007).
  $8EC1,$02,b$01 OR #N$80 into the parameter.
@ $8EC3 label=PrintHandler_RightMargin_Store
  $8EC3,$03 Write the parameter to *#R$8006 (right margin X position).
  $8EC6,$01 Return.
@ $8EC7 label=PrintHandler_SelectFont
N $8EC7 Select font parameter handler. Called on the byte immediately following a #N$1A
. control code. Copies the six-byte font configuration for the selected font index
. (#N$00–#N$03) from the table at #R$8FE6 into the font state at #N$800C, and
. loads the font bitmap pointer into #N$8008.
  $8EC7,$02 #REGb=#N$04 (mask limit: font indices #N$00–#N$03).
  $8EC9,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to the font index.
  $8ECC,$02 #REGh=#N$00.
  $8ECE,$01 #REGl=#REGb (font index as a 16-bit value in #REGhl).
  $8ECF,$03 #REGde=#R$8FE6 (font configuration table base).
N $8ED2 Multiply the font index by #N$08 (the size of each font table entry) to compute
. the byte offset into the font table.
  $8ED2,$03 Multiply #REGhl by #N$08 (three left shifts).
  $8ED5,$01 #REGhl=#R$8FE6 + (font index × #N$08) — pointer to the selected font entry.
  $8ED6,$03 #REGde=#N$800C (font state destination).
  $8ED9,$03 #REGbc=#N$0006 (six bytes of font configuration to copy).
  $8EDC,$02 Copy six bytes of font configuration to #N$800C–#N$8011.
  $8EDE,$03 Read the two-byte font bitmap pointer from bytes #N$07–#N$08 of the entry.
  $8EE1,$04 Write the font bitmap pointer to *#R$8008.
  $8EE5,$01 Return.
@ $8EE6 label=PrintHandler_MaskParam
N $8EE6 Parameter mask and validation utility. Called by control code parameter handlers
. before processing their byte. Resets #R$800A to the default handler (#R$8DE3),
. then masks #REGa to the valid range defined by #REGb (which must be a power of
. two). If the parameter is out of range, sets a flag in #N$8007.
  $8EE6,$06 Reset #R$800A to #R$8DE3 (default handler).
  $8EEC,$01 Test whether the parameter (#REGa) is within the valid range (#REGb).
  $8EED,$02 If the parameter is within range, jump to #R$8EF3.
  $8EEF,$04 Otherwise set the out-of-range flag (bit 0 of *#N$8007).
@ $8EF3 label=PrintHandler_MaskParam_Mask
  $8EF3,$01 Decrement #REGb to form a bitmask (e.g. #N$08 → #N$07 = %00000111).
  $8EF4,$01 Mask #REGa to the valid range.
  $8EF5,$01 #REGb=masked parameter value.
  $8EF6,$01 Return.
@ $8EF7 label=PrintHandler_Render
N $8EF7 Character renderer. Determines the pixel width of the character, checks whether
. it fits on the current line (inserting a carriage return if not), computes the
. screen address from the current X and Y pixel positions, bit-shifts the character
. bitmap from the font table, ORs it into screen memory row by row, writes the
. attribute byte to the attribute area, and finally advances the X position.
  $8EF7,$03 Store the character code to *#R$8003.
N $8EFA Select the pixel width for the character. Space (#N$20), "#CHR$49" (#N$49), "#CHR$4D"
. (#N$4D) and "#CHR$57" (#N$57) each have their own width stored in the font state at
. #N$800C. All other printable characters use the normal width.
  $8EFA,$04 If the character is a space (#N$20), jump to #R$8F07.
  $8EFE,$04 If the character is not "#CHR$49" (#N$49), jump to #R$8F0C.
  $8F02,$03 #REGc=*#R$800D (narrow width for "#CHR$49").
  $8F05,$02 Jump to #R$8F1C.
@ $8F07 label=PrintHandler_Render_SpaceWidth
  $8F07,$03 #REGc=*#R$800F (space width).
  $8F0A,$02 Jump to #R$8F1C.
@ $8F0C label=PrintHandler_Render_WideCheck
N $8F0C Check for wide characters: "#CHR$4D" (#N$4D) and "#CHR$57" (#N$57) use the wide width.
  $8F0C,$04 If the character is "#CHR$4D" (#N$4D), jump to #R$8F14.
  $8F10,$04 If the character is not "#CHR$57" (#N$57), jump to #R$8F19 (normal width).
@ $8F14 label=PrintHandler_Render_WideWidth
  $8F14,$03 #REGc=*#R$800E (wide width for "#CHR$4D" and "#CHR$57").
  $8F17,$02 Jump to #R$8F1C.
@ $8F19 label=PrintHandler_Render_NormalWidth
N $8F19 All other printable characters use the standard (#REGix+#N$0C) width.
  $8F19,$03 #REGc=*#R$800C (normal character width).
@ $8F1C label=PrintHandler_Render_LineCheck
N $8F1C Check whether the character fits within the right margin. If adding the character
. width to the current X position would exceed the right margin stored at #N$8006, a
. carriage return is inserted automatically before rendering.
  $8F1C,$04 #REGb=*#R$8001 (current X position).
  $8F20,$03 #REGa=*#R$8006 (right margin X position).
  $8F23,$02 #REGa=right margin − current X − character width.
  $8F25,$03 Call #R$8E0F if the result is negative (character exceeds the right margin).
N $8F28 Calculate the screen address and sub-byte bit-shift from the current X and Y
. pixel positions. The screen row address LUT (indexed by Y) provides the base pixel
. row address; three right-shifts of X derive the column byte offset and the
. within-byte pixel shift (0–7 bits).
  $8F28,$01 #REGa=character width.
  $8F29,$01 Stash character width in #REGa'.
  $8F2A,$03 #REGa=*#R$8000 (Y pixel position).
  $8F2D,$07 #REGhl=screen row address LUT entry for pixel row Y (#N$8C00 + Y × #N$02).
  $8F34,$03 #REGa=*#R$8001 (X pixel position).
  $8F37,$0C Clear carry; #REGb=#N$00; shift #REGa right three positions with carry into
. #REGb, deriving the column byte offset (#REGa=X÷8) and sub-byte pixel bits (low
. #N$03 bits of X → #REGb).
  $8F43,$06 Rotate #REGb left three positions to place the sub-byte offset in bits 0–2.
  $8F49,$01 #REGc=column byte offset (X÷8).
  $8F4A,$04 Store the sub-byte pixel shift (X mod 8) to *#R$8002.
@ $8F54 label=PrintHandler_Render_AddrLoop
  $8F4E,$03 #REGde=#N$8012 (screen address workspace).
  $8F51,$03 #REGb=*#R$8011 (number of character pixel rows).
  $8F54,$09 Read each two-byte screen row address from the LUT into the workspace at
. #N$8012, adding the column byte offset (#REGc) to the first byte of each pair.
  $8F5D,$02 Decrease the row counter and loop back to #R$8F54 until all rows are done.
N $8F5F Look up the character bitmap in the font table. Each character occupies
. #N$08 bytes at font base pointer + (character code × #N$08).
  $8F5F,$03 #REGa=*#R$8003 (character code).
  $8F62,$03 #REGhl=character code as a 16-bit value.
  $8F65,$04 #REGde=*#R$8008 (font bitmap base pointer).
  $8F69,$04 #REGhl=font base + (character code × #N$08).
  $8F6D,$01 #REGde=pointer to the character bitmap data.
  $8F6E,$03 #REGhl=#N$8022 (bit-shift workspace).
  $8F71,$03 #REGc=*#R$8011 (number of character pixel rows).
@ $8F74 label=PrintHandler_Render_ShiftLoop
  $8F74,$03 #REGb=*#R$8002 (sub-byte pixel shift count); #REGa=shift count.
  $8F77,$01 #REGb=pixel shift count.
  $8F78,$02 Copy one row of font bitmap data from *#REGde to *#REGhl.
  $8F7A,$04 If the shift count is #N$00, jump to #R$8F84 (no shift needed).
  $8F7E,$01 Clear #REGa (right-hand overflow byte).
@ $8F7F label=PrintHandler_Render_ShiftStep
  $8F7F,$05 Shift *#REGhl right through carry into #REGa, repeating for each shift step.
@ $8F84 label=PrintHandler_Render_ShiftNext
  $8F84,$01 Advance #REGhl to the second byte of the workspace pair.
  $8F85,$01 Store the shifted overflow byte (right-hand spill) to *#REGhl.
  $8F86,$01 Advance #REGhl to the next row pair in the workspace.
  $8F87,$01 Advance #REGde to the next row of font bitmap data.
  $8F88,$01 Decrease the row counter.
  $8F89,$02 Loop back to #R$8F74 until all rows have been bit-shifted.
N $8F8B Write the attribute byte to the four attribute cells covering the character.
. Derives the attribute address from the screen pixel address high byte by rotating
. right three times, masking to two bits, and OR-ing with #N$58 ($5800 base).
  $8F8B,$03 #REGbc=#N$8022 (bit-shifted bitmap workspace pointer).
  $8F8E,$03 #REGhl=#N$8012 (screen address workspace pointer).
  $8F91,$04 Stash #REGhl; read the first screen address pair into #REGde.
  $8F95,$01 Restore #REGhl from the pair.
  $8F96,$01 #REGde=screen pixel row address.
  $8F97,$06 Derive the attribute memory high byte from the pixel address high byte.
  $8F9D,$02 #REGh=#N$58 | column third → attribute address high byte.
  $8F9F,$01 #REGh=attribute address high byte.
  $8FA0,$03 #REGa=*#R$8004 (attribute byte: INK/PAPER/BRIGHT/FLASH).
  $8FA3,$03 Write the attribute byte to the two cells at *#REGhl and *(#REGhl+#N$01).
  $8FA6,$03 #REGde=#N$001F (offset to next attribute row).
  $8FA9,$04 Write the attribute byte to the two cells in the attribute row below.
  $8FAD,$01 Restore the screen address workspace pointer from the stack.
@ $8FB2 label=PrintHandler_Render_BlitLoop
  $8FAE,$04 Switch to shadow registers; #REGb=*#R$8011 (pixel row count).
  $8FB2,$05 Switch back; #REGde=next two-byte screen address from #N$8012+.
  $8FB7,$01 #REGde=screen pixel row address.
  $8FB8,$04 OR the left bitmap byte from *#REGbc into *#REGde (left screen byte).
  $8FBC,$05 Advance #REGhl; OR the right bitmap byte from *#REGbc into *(#REGhl); advance #REGbc.
  $8FC1,$01 #REGde=screen address workspace pointer (restore via EX DE,HL swap).
  $8FC2,$03 Switch to shadow registers and loop back to #R$8FB2 until all pixel rows are
. blitted to screen memory.
N $8FC5 Advance the X position by the character's pixel width and return.
  $8FC5,$02 Switch back to main registers; restore character width from #REGa'.
  $8FC7,$01 #REGc=character width.
  $8FC8,$03 #REGa=*#R$8001 (current X position).
  $8FCB,$01 #REGa+=character width.
  $8FCC,$03 Write the new X position to *#R$8001.
  $8FCF,$01 Return.

g $8FD0 Control Code Dispatch Table
@ $8FD0 label=ControlCode_DispatchTable
D $8FD0 Two-byte handler address table for control codes #N$10–#N$1A, indexed by the
. control code zero-indexed from #N$10. Each entry is the address of the parameter
. handler installed into #R$800A by #R$8DE3.
W $8FD0,$02 #N$10: INK colour — parameter handler at #R$8E2E.
W $8FD2,$02 #N$11: PAPER colour — parameter handler at #R$8E3D.
W $8FD4,$02 #N$12: FLASH — parameter handler at #R$8E52.
W $8FD6,$02 #N$13: BRIGHT — parameter handler at #R$8E65.
W $8FD8,$02 #N$14: Unsupported — parameter consumed and discarded via #R$8E23.
W $8FDA,$02 #N$15: Unsupported — parameter consumed and discarded via #R$8E23.
W $8FDC,$02 #N$16: PRINT AT column — parameter handler at #R$8E78.
W $8FDE,$02 #N$17: TAB — parameter handler at #R$8E92.
W $8FE0,$02 #N$18: Set left margin — parameter handler at #R$8EAA.
W $8FE2,$02 #N$19: Set right margin — parameter handler at #R$8EB3.
W $8FE4,$02 #N$1A: Select font — parameter handler at #R$8EC7.

g $8FE6 Font Configuration Table
@ $8FE6 label=FontConfig_Table
D $8FE6 Font configuration table, indexed by font number (#N$00–#N$03). Each eight-byte
. entry comprises six bytes of font metrics copied to #N$800C–#N$8011 by the select
. font handler at #R$8EC7, followed by a two-byte little-endian pointer to the font
. bitmap data stored at #N$8008.
  $8FE6,$06 Font #N$00: normal width, narrow width ("#CHR$49"), wide width ("#CHR$4D"/ "#CHR$57"), space
. width, line height, and pixel row count.
B $8FEC,$02 Font #N$00: pointer to font bitmap data.
B $8FEE,$04 Font #N$01: normal width, narrow width, wide width, and space width.

g $8FF2

c $9006 Print Messaging
@ $9006 label=PrintMessaging
R $9006 HL Pointer to the messaging string
  $9006,$01 Fetch the byte from the messaging string.
  $9007,$03 Return if the terminator byte was read (#N$1F).
  $900A,$03 Call #R$8DCC.
  $900D,$01 Increment the messaging pointer by one.
  $900E,$02 Jump back to #R$9006 to continue printing.

c $9010
D $9010 #SIM(start=$9010,stop=$903C)#SCR$02(test-01)

c $9044 Reset Print State
@ $9044 label=ResetPrintState
  $9044,$06 Write #R$8DE3 to *#R$800A.
  $904A,$06 Call #R$9006 using #R$9051.
  $9050,$01 Return.

t $9051 Messaging: Reset
@ $9051 label=Messaging_Reset
B $9051,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $9053,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $9055,$02 FLASH: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $9057,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $9059,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $905C,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $905E,$02 Set right margin: #N(#PEEK(#PC+$01)).
B $9060,$02 Select font: #N(#PEEK(#PC+$01)).
B $9062,$01 Terminator.

c $9063

c $C400 Game Entry Point Alias
@ $C400 label=GameEntryPointAlias
  $C400,$03 Jump to #R$EBBC.

g $C403 Player 1 State
@ $C403 label=Player_1_State

g $C408 Wave Number
@ $C408 label=WaveNumber

g $C409

g $C415 Lives
@ $C415 label=Lives
B $C415,$01

g $C416 Wave
@ $C416 label=Wave
B $C416,$01

g $C417

g $C418

g $C41C
B $C41C,$01

g $C41D Wave Display X Pixel Position
@ $C41D label=WaveDisplay_X_PixelPosition

g $C41E Two-Player Session Flag
@ $C41E label=TwoPlayerSessionFlag
D $C41E Non-zero when both player slots take part in the current credit session; read
. by #R$D367 after a lost life to decide whether to swap with #R$D08B again or loop
. on the same player. Cleared when initialising state for a new game after the
. maximum wave.
B $C41E,$01

g $C42E

g $C447 Player 2 State
@ $C447 label=Player_2_State

g $C46E

g $C48B

g $C4F8

g $C4FD
g $C4FE

g $C519 Wave Start Pointer
@ $C519 label=WaveStartPointer
D $C519 Little-endian pointer loaded from the word table at #R$D3E4 (indexed from
. #R$D400) when staging a wave after tape load or max-wave reset; copied into
. #R$C409 when clearing player state in #R$D367.
W $C519,$02

g $C532 Death Sequence Mode
@ $C532 label=DeathSequenceMode
D $C532 When #N$01, #R$D367 skips the intro HUD, "PLAYER" messaging and intro delay
. before losing a life, and skips the extra "PLAYER" line in the game-over branch.
. Set from the wave-table path together with the table variant in #REGb.
B $C532,$01

c $C544

c $C713

c $C794

w $C7CF

c $C84F

c $C77D Poll H Key
@ $C77D label=PollHKey
D $C77D Reads keyboard port #N$BF bit 4 (the "H" key) on each pass of the inner
. loop. Key bits are active-low (#N$00 = pressed); if "H" is not pressed, #REGd is
. decremented, otherwise #REGe is decremented. Called from #R$C713 while handling the
. attribute bar after the key has been detected.
  $C77D,$02 Initialise #REGd to #N$15 (down-counter for "H" not pressed).
  $C77F,$02 Initialise #REGe to #N$15 (down-counter for "H" pressed).
  $C781,$02 Set an inner loop counter to #N$14 loops.
@ $C783 label=PollHKey_Loop
  $C783,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
  $C787,$02,b$01 Keep only bit 4 ("H" key).
  $C789,$03 If "H" is not pressed (bit 4 is 1), jump to #R$C790 to decrement #REGd.
N $C78C "H" key was pressed.
  $C78C,$01 Decrease #REGe by one.
  $C78D,$03 Jump to #R$C791 (skip the #REGd decrement).
@ $C790 label=PollHKey_NotPressed
  $C790,$01 Decrease #REGd by one.
@ $C791 label=PollHKey_Continue
  $C791,$02 Decrease the inner loop counter and loop back to #R$C783 until it reaches zero.
  $C793,$01 Return.

c $D070 Clear Screen Buffer
@ $D070 label=ClearScreenBuffer
  $D070,$0D Clear #N$1800 bytes of data from #R$4000(#N$4000) to #N$5B00.
  $D07D,$01 Return.

c $D07E Set Background Colour
@ $D07E label=SetBackgroundColour
R $D07E A Attribute byte to fill the entire attribute area with
  $D07E,$0C Write #REGa to #N$02FF bytes of data from #N$5800 to #N$5AFF.
  $D08A,$01 Return.

c $D08B Swap Player State
@ $D08B label=SwapPlayerState
D $D08B Swaps the active and inactive player's #N$44-byte game state blocks
. between the player 1 slot at #R$C403 and the player 2 slot at #R$C447,
. using #R$C48B as a temporary buffer. Called each time the game switches
. between the two players.
  $D08B,$03 #REGhl=#R$C403 (player 1 state source).
  $D08E,$03 #REGde=#R$C48B (temporary buffer destination).
  $D091,$03 #REGbc=#N($0044,$04,$04) (#N$44 bytes = one player state block).
  $D094,$02 Copy player 1 state to the temporary buffer; #REGhl advances to #R$C447 (player 2 state).
  $D096,$03 #REGde=#R$C403 (player 1 slot destination).
  $D099,$03 #REGbc=#N($0044,$04,$04).
  $D09C,$02 Copy player 2 state (from #R$C447) into the player 1 slot.
  $D09E,$03 #REGhl=#R$C48B (saved player 1 state source).
  $D0A1,$03 #REGbc=#N($0044,$04,$04).
  $D0A4,$02 Copy saved player 1 state into the player 2 slot (at #R$C447).
  $D0A6,$01 Return.

c $D0A7 Print Wave Number
@ $D0A7 label=PrintWaveNumber
D $D0A7 Prints the current wave number at pixel position X=*#R$C41D, Y=#N$BB
. using the print dispatch system at #R$8DCC. The wave number is stored in
. packed BCD at #R$C408: the high nibble holds the tens digit and the low
. nibble holds the units digit; each is OR'd with #N$30 to convert it to
. an ASCII decimal character before dispatch. Font #N$00 is selected for
. rendering and font #N$01 is restored on return.
  $D0A7,$05 Call #R$8DCC with #N$1A (Select Font control code).
  $D0AC,$05 Call #R$8DCC with #N$00 (font #N$00).
  $D0B1,$05 Call #R$8DCC with #N$16 (PRINT AT control code).
  $D0B6,$03 #REGa=*#R$C41D (X pixel position for the wave number display).
  $D0B9,$03 Call #R$8DCC; the PRINT AT X handler stores the X position and installs the Y handler.
  $D0BC,$02 #REGa=#N$BB (Y pixel position).
  $D0BE,$03 Call #R$8DCC; the PRINT AT Y handler stores the Y position and restores the default handler.
  $D0C1,$03 #REGa=*#R$C408 (BCD wave number).
  $D0C4,$08 Shift #REGa right four positions to isolate the tens digit (high nibble, #N$0–#N$9).
  $D0CC,$02,b$01 Convert the tens digit to its ASCII character ("#CHR$30"–"#CHR$39").
  $D0CE,$03 Call #R$8DCC to print the tens digit.
  $D0D1,$03 #REGa=*#R$C408 (BCD wave number again).
  $D0D4,$02,b$01 Isolate the units digit (low nibble, #N$0–#N$9).
  $D0D6,$02,b$01 Convert the units digit to its ASCII character ("#CHR$30"–"#CHR$39").
  $D0D8,$03 Call #R$8DCC to print the units digit.
  $D0DB,$05 Call #R$8DCC with #N$1A (Select Font control code).
  $D0E0,$05 Call #R$8DCC with #N$01 (restore font #N$01).
  $D0E5,$01 Return.

t $D0E6 Messaging: Wave
@ $D0E6 label=Messaging_Wave
B $D0E6,$02 Select font: #N(#PEEK(#PC+$01)).
B $D0E8,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $D0EB,$04
B $D0EF,$01 Terminator.

c $D0F0

c $D30C
  $D30C,$03 Call #R$D070.
  $D30F,$05 Call #R$D07E using #INK$07.
  $D314,$03 Jump to #R$D325.

c $D317 Render HUD
@ $D317 label=RenderHUD
D $D317 Clears the screen buffer, sets a white background, triggers the wave
. indicator animation (#R$D570), and redraws the attribute bar (#R$C713)
. before falling through to #R$D325. Scores (#R$C544) and lives (#R$C794)
. are then rendered for each player in turn by swapping state with #R$D08B;
. the "WAVE" label and wave number (#R$D0A7) are printed last for player 1.
  $D317,$03 Call #R$D070.
  $D31A,$05 Call #R$D07E using #INK$07.
  $D31F,$03 Call #R$D570.
  $D322,$03 Call #R$C713.
@ $D325 label=RenderHUD_Draw
N $D325 Shared entry point, also reached from #R$D30C via JP (which clears the
. screen and sets the background but skips the wave animation and attribute
. bar setup). Renders scores and lives for player 1, then swaps to player 2.
  $D325,$03 Call #R$C544.
  $D328,$03 Call #R$C794.
N $D32B Swap to player 2 to render their score, lives and wave number.
  $D32B,$03 Call #R$D08B.
  $D32E,$03 Call #R$C544.
  $D331,$03 Call #R$C794.
  $D334,$03 Call #R$D0A7.
N $D337 Swap back to player 1; print the "WAVE" label and player 1's wave number,
. then redraw the attribute bar to complete the HUD.
  $D337,$03 Call #R$D08B.
  $D33A,$06 Call #R$9006 using #R$D0E6.
  $D340,$03 Call #R$D0A7.
  $D343,$03 Call #R$C713.
  $D346,$01 Return.

t $D347 Messaging: Player
@ $D347 label=Messaging_Player
B $D347,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $D349,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $D34B,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $D34E,$07
B $D355,$01 Terminator.

t $D356 Messaging: Game Over
@ $D356 label=Messaging_GameOver
B $D356,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $D358,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $D35A,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $D35D,$09
B $D366,$01 Terminator.

c $D367 Player Death
@ $D367 label=PlayerDeath
D $D367 Handles a lost life and game-over flow: optional HUD and "PLAYER" messaging,
. decrementing #R$C415, calling #R$D24C to re-stage the wave, swapping players with
. #R$D08B, printing "GAME OVER" when no lives remain, and either returning to the
. attract mode at #R$EBBC or looping. A lookup table at #R$D3E4 (read from #R$D400)
. supplies a start pointer stored at #R$C519; #R$ECFB jumps to #R$D3F8 after a
. successful tape load. Clears player state at #R$C403, wave and score fields, and
. applies #R$D481 (reset margins) when starting a fresh game.
  $D367,$03 #REGa=*#R$C532 (death-sequence mode; #N$01 = skip the intro HUD/delay).
  $D36A,$02 Compare with #N$01.
  $D36C,$02 If set, jump to #R$D38B to decrement #R$C415 immediately.
N $D36E Full death sequence: redraw the HUD (#R$D317), print #R$D347 ("PLAYER") via
. #R$9006, then print the current player digit from *#R$C41F as ASCII (#N$30–#N$39).
  $D36E,$03 Call #R$D317.
  $D371,$06 Call #R$9006 using #R$D347.
  $D377,$03 #REGa=*#R$C41F (player index for the digit).
  $D37A,$02,b$01 Convert to ASCII ("#CHR$30"–"#CHR$39").
  $D37C,$03 Call #R$8DCC (print dispatch).
  $D37F,$02 Inner delay loop count #N$20 (#REGb=#N$20).
@ $D381 label=PlayerDeath_IntroDelay
  $D381,$01 Stash #REGbc on the stack.
  $D382,$03 Call #R$DAA3 (short delay).
  $D385,$03 Call #R$C713 (attribute bar).
  $D388,$01 Restore #REGbc from the stack.
  $D389,$02 Decrease counter and loop back to #R$D381 until the intro delay finishes.

N $D38B See #POKE(infinite-lives)(Infinite Lives (Final Version)).

@ $D38B label=PlayerDeath_LoseLife
  $D38B,$03 #REGhl=#R$C415 (lives counter).
  $D38E,$01 Decrease *#REGhl (lose one life).
  $D38F,$03 Call #R$D24C (re-stage the wave / death handling).
  $D392,$06 Jump to #R$D3A7 if *#R$C415 shows no lives are left.
N $D398 Lives remain: swap to the other player and continue if two-player mode.
  $D398,$03 Call #R$D08B.
N $D39B If not two-player, jump back to #R$D367 for the same player.
  $D39B,$07 Jump back to #R$D367 if *#R$C41E is not set.
  $D3A2,$03 Call #R$D08B (swap back).
  $D3A5,$02 Jump back to #R$D367.

@ $D3A7 label=PlayerDeath_GameOver
N $D3A7 No lives left: redraw the HUD, then either the "PLAYER" line or straight to
. "GAME OVER" depending on *#R$C532, with a longer delay loop.
  $D3A7,$03 Call #R$D317.
  $D3AA,$07 Jump to #R$D3BF if *#R$C532 is #N$01.
  $D3B1,$06 Call #R$9006 using #R$D347.
  $D3B7,$03 #REGa=*#R$C41F.
  $D3BA,$02,b$01 Convert to ASCII.
  $D3BC,$03 Call #R$8DCC.
@ $D3BF label=PlayerDeath_GameOverDelay
  $D3BF,$06 Call #R$9006 using #R$D356.
  $D3C5,$02 Longer delay loop count #N$29 (#REGb=#N$29).
@ $D3C7 label=PlayerDeath_GameOverDelayLoop
  $D3C7,$01 Stash #REGbc on the stack.
  $D3C8,$03 Call #R$DAA3.
  $D3CB,$03 Call #R$C713.
  $D3CE,$01 Restore #REGbc from the stack.
  $D3CF,$02 Decrease counter and loop back to #R$D3C7.
N $D3D1 Set *#R$C41E to #N$01, swap players with #R$D08B, then branch on the flag
. read back from *#R$C41E.
  $D3D1,$05 Write #N$01 to *#R$C41E.
  $D3D6,$03 Call #R$D08B.
  $D3D9,$08 Jump to #R$EBBC if *#R$C41E is #N$01 (attract mode).
  $D3E1,$03 Jump back to #R$D367.

g $D3E4
B $D3E4,$14

c $D3F8 Player Death: Tape Load Continue
@ $D3F8 label=PlayerDeath_TapeLoadContinue
R $D3F8 B Scratch (from the tape block header at *#R$C4FD).
R $D3F8 E Scratch (from the tape block header at *#R$C4FE).
N $D3F8 This routine is called after a successful tape load.
  $D3F8,$03 Load #REGa with *#R$C4FE.
  $D3FB,$01 Decrease #REGa by one.
  $D3FC,$02 #REGe=#REGa multiplied by #N$02.
  $D3FE,$02 #REGd=#N$00 (high byte of index).
  $D400,$03 #REGhl=#R$D3E4 (base of the lookup table).
  $D403,$01 Add #REGde into #REGhl (index into the table).
  $D404,$01 #REGa=*(#REGhl) (low byte of the table word).
  $D405,$01 Advance #REGhl.
  $D406,$01 #REGh=*(#REGhl) (high byte of the table word).
  $D407,$01 #REGl=#REGa (little-endian word in #REGhl).
  $D408,$03 Write the pointer to *#R$C519.
  $D40B,$04 Write #REGb (variant/ slot) to *#R$C532.
  $D40F,$07 Jump to #R$D41B if *#R$C416 is at the maximum wave.
  $D416,$01 Stash #REGbc on the stack.
  $D417,$03 Call #R$D08B.
  $D41A,$01 Restore #REGbc from the stack.
N $D41B Set the starting lives.
@ $D41B label=PlayerDeath_InitMaxWave
  $D41B,$05 Write #N$03 to *#R$C415.
  $D420,$04 Write #N$00 to *#R$C41E.
  $D424,$08 Write #COLOUR$44 (#N$44) to; #LIST
. { *#R$C42E }
. { *#R$C46E }
. LIST#
  $D42C,$05 Jump to #R$D442 (margins + clear) if this is player #N$01.
  $D431,$03 Call #R$D08B.
  $D434,$05 Write #N$03 to *#R$C415.
  $D439,$04 Write #N$00 to *#R$C41E.
  $D43D,$05 Write #COLOUR$44 (#N$44) to *#R$C42E.

@ $D442 label=PlayerDeath_NewGameSetup
  $D442,$06 Call #R$9006 using #R$D481.
  $D448,$01 #REGa=#N$00.
  $D449,$02 Outer loop: two player slots (#REGb=#N$02).
@ $D44B label=PlayerDeath_ClearPlayerSlot
  $D44B,$03 #REGhl=#R$C403 (player 1 state block).
  $D44E,$02 Clear #N$04 bytes per slot (#REGc=#N$04).
@ $D450 label=PlayerDeath_ClearPlayerBytes
  $D450,$01 Write #REGa to *#REGhl.
  $D451,$01 Advance #REGhl.
  $D452,$01 Decrease #REGc.
  $D453,$02 Loop back to #R$D450 until the slot prefix is cleared.
  $D455,$03 Write #REGa to *#R$C408.
  $D458,$03 Write #REGa to *#R$C41C.
  $D45B,$03 #REGhl=#R$C418.
  $D45E,$01 Write #REGa to *#REGhl.
  $D45F,$01 Advance #REGhl.
  $D460,$02 Write #N$02 to *#REGhl.
  $D462,$01 Advance #REGhl.
  $D463,$01 Write #REGa to *#REGhl.
  $D464,$01 Advance #REGhl.
  $D465,$01 Write #REGa to *#REGhl.
  $D466,$06 Write *#R$C519 to *#R$C409.
  $D46C,$01 Stash #REGbc on the stack.
  $D46D,$03 Call #R$D08B.
  $D470,$01 Restore #REGbc from the stack.
  $D471,$02 Decrease outer counter and loop back to #R$D44B for the second player.
  $D473,$08 Jump back to #R$D367 if *#R$C416 is still at the maximum wave.
  $D47B,$03 Call #R$D08B.
  $D47E,$03 Jump back to #R$D367.

t $D481 Messaging: Reset Margins
@ $D481 label=Messaging_ResetMargins
B $D481,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $D483,$02 Set right margin: #N(#PEEK(#PC+$01)).
B $D485,$01 Terminator.

c $D486

c $D562

c $D570

c $D5B1

b $D620

c $D630

c $EBBC Game Entry Point
@ $EBBC label=GameEntryPoint
  $EBBC,$03 #REGsp=#N$5FFE.
  $EBBF,$01 Disable interrupts.
  $EBC0,$05 Write #N$08 to *#R$8FF2.
  $EBC5,$03 Jump to #R$F4EC.

c $EBC8

c $ECA4
  $ECA4,$03 #REGhl=#N$4000.
  $ECA7,$03 #REGde=#N$4001 (screen buffer location).
  $ECAA,$03 #REGbc=#N$1800.
  $ECAD,$02 Write #N$00 to *#REGhl.
  $ECAF,$02 LDIR.
  $ECB1,$03 #REGbc=#N$0300.
  $ECB4,$01 Write #REGa to *#REGhl.
  $ECB5,$02 LDIR.
  $ECB7,$02,b$01 Keep only bits 3-5.
  $ECB9,$02 Test bit 5 of #REGa.
  $ECBB,$02 Jump to #R$ECBF if ?? is not equal to #N$00.
  $ECBD,$02,b$01 Flip bits 0-2.
  $ECBF,$03 #HTML(Write #REGa to *<a href="https://skoolkid.github.io/rom/asm/5C48.html">BORDCR</a>.)
  $ECC2,$02,b$01 Keep only bits 3-5.
  $ECC4,$03 Rotate right with carry three positions.
  $ECC7,$02 Set border to the colour held by #REGa.
  $ECC9,$01 Return.

  $ECCA,$01 #REGa+=#REGa.
  $ECCB,$01 #REGa+=#REGa.
  $ECCC,$01 #REGa+=#REGa.
  $ECCD,$01 #REGa+=#REGb.
  $ECCE,$03 Call #R$EE0B.
  $ECD1,$03 Call #R$EE1D.
  $ECD4,$01 Return.

  $ECD5,$01 #REGa+=#REGa.
  $ECD6,$02 #REGa+=#N$01.
  $ECD8,$01 #REGl=#REGa.
  $ECD9,$02 #REGh=#N$59.
  $ECDB,$02 Write #N$47 to *#REGhl.
  $ECDD,$01 Return.

c $ECDE

c $ECE6 Check BREAK Key
@ $ECE6 label=CheckBreakKey
D $ECE6 Checks whether the BREAK key combination (CAPS SHIFT + SPACE) is held
. while *#N$FFFF equals #N$63. Called during the attract mode loop and option
. screens. If both conditions are met, the ROM error handler is invoked via
. RST #N$08 (parameter #N$14), which jumps via ERRSP (#N$5C3D) to reset the
. machine.
  $ECE6,$06 Return if *#N$FFFF is not equal to #N$63.
N $ECEC Read both halves of the BREAK key combination. Keyboard bits are
. active-low (#N$00 when pressed); OR-ing the two readings and masking to
. bit 0 gives #N$00 only when both keys are held simultaneously.
  $ECEC,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FE | CAPS SHIFT | Z | X | C | V }
. TABLE#
  $ECF1,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$7F | SPACE | FULL-STOP | M | N | B }
. TABLE#
  $ECF5,$01 OR with the CAPS SHIFT reading; bit 0 is #N$00 only if both are pressed.
  $ECF6,$02,b$01 Keep only bit 0.
  $ECF8,$01 Return if CAPS SHIFT and SPACE are not both held (BREAK not detected).
N $ECF9 Both conditions confirmed; trigger the ROM error handler which jumps via ERRSP (#N$5C3D) to reset the machine.
  $ECF9,$01 #HTML(Run the ERROR_1 routine:
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0008.html">RST #N$08</a>.)
B $ECFA,$01 Error code: #N$14 ("BREAK into program").

c $ECFB

c $ED10
  $ED10,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
  $ED15,$02,b$01 Keep only bits 1, 3.
  $ED17,$01 Return if ?? is equal to #N$00.
  $ED18,$03 #REGde=#N($012D,$04,$04).
  $ED1B,$02 Test bit 1 of #REGa.
  $ED1D,$02 #REGa=#N$6B.
  $ED1F,$02 Jump to #R$ED2A if ?? is not equal to #N$6B.
  $ED21,$04 #REGix=#N$F1AB.
  $ED25,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/04C2.html">SA_BYTES</a>.)
  $ED28,$01 Disable interrupts.
  $ED29,$01 Return.
  $ED2A,$01 Set the carry flag.
  $ED2B,$04 #REGix=#R$6100.
  $ED2F,$03 #HTML(Call <a href="https://skoolkit.ca/disassemblies/rom/hex/asm/0556.html">LD_BYTES</a>.)
  $ED32,$01 Restore #REGde from the stack.
  $ED33,$01 Disable interrupts.
  $ED34,$02 Jump to #R$ED63 if ?? is less than #N$6B.
  $ED36,$01 #REGa=#REGl.
  $ED37,$03 #REGhl=#N$EFBC.
  $ED3A,$04 Jump to #R$ED41 if #REGa is not equal to #N$6C.
  $ED3E,$03 #REGhl=#R$EFDD.
  $ED41,$01 Stash #REGhl on the stack.
  $ED42,$01 #REGa=#N$00.
  $ED43,$03 Call #R$ECA4.
  $ED46,$03 Call #R$F09D.
  $ED49,$03 Call #R$F0EE.
  $ED4C,$01 Restore #REGhl from the stack.
  $ED4D,$03 Call #R$9006.
  $ED50,$02 #REGc=#N$64.
  $ED52,$03 Call #R$ECDE.
  $ED55,$03 Call #R$ED7C.
  $ED58,$03 Call #R$F0EE.
  $ED5B,$03 Call #R$ECE6.
  $ED5E,$03 Call #R$ED71.
  $ED61,$02 Jump to #R$ED50.

  $ED63,$03 #REGhl=#R$6100.
  $ED66,$03 #REGde=#N$F1AB.
  $ED69,$03 #REGbc=#N$012D.
  $ED6C,$02 LDIR.
  $ED6E,$03 Jump to #R$EC75.

c $ED71

c $ED7C

c $EE0B

c $EE1D

b $EE28

t $EE66 Messaging: Select Options
@ $EE66 label=Messaging_SelectOptions
B $EE66,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $EE68,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $EE6A,$02 Set right margin: #N(#PEEK(#PC+$01)).
B $EE6C,$02 Select font: #N(#PEEK(#PC+$01)).
B $EE6E,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $EE70,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EE72,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $EE75,$0F
B $EE84,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $EE86,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EE88,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $EE8B,$0C
B $EE97,$01 NEWLINE.
  $EE98,$0C
B $EEA4,$01 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EEA5,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $EEA8,$15
B $EEBD,$01 NEWLINE.
  $EEBE,$1B
B $EED9,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $EEDB,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EEDD,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $EEE0,$1A
B $EEFA,$01 NEWLINE.
  $EEFB,$13
B $EF0E,$01 NEWLINE.
  $EF0F,$11
B $EF20,$01 NEWLINE.
  $EF21,$23
B $EF44,$01 NEWLINE.
  $EF45,$1B
B $EF60,$01 NEWLINE.
  $EF61,$0A
B $EF6B,$01 NEWLINE.
  $EF6C,$0F
B $EF7B,$01 NEWLINE.
  $EF7C,$12
B $EF8E,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EF90,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $EF93,$0C
B $EF9F,$01 NEWLINE.
  $EFA0,$0E
B $EFAE,$01 NEWLINE.
  $EFAF,$0C
B $EFBB,$01 Terminator.

t $EFBC Messaging: Tape Error
@ $EFBC label=Messaging_TapeError
B $EFBC,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $EFBE,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $EFC1,$02 Select font: #N(#PEEK(#PC+$01)).
  $EFC3,$19
B $EFDC,$01 Terminator.

t $EFDD Messaging: High Score Error
@ $EFDD label=Messaging_HighScoreError
B $EFDD,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $EFDF,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $EFE1,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $EFE4,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $EFE6,$02 Select font: #N(#PEEK(#PC+$01)).
  $EFE8,$08
B $EFF0,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $EFF2,$43
B $F035,$02 TAB: #N(#PEEK(#PC+$01)).
  $F037,$13
B $F04A,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $F04C,$01 Terminator.

c $F04D

c $F09D

c $F0AE

g $F0DE
W $F0DE,$02
L $F0DE,$02,$08

c $F0EE

c $F107

t $F165 Table: Robotron Heroes
N $F165 Position: #N($01+(#PC-$F165)/$07).
  $F165,$03 Name.
B $F168,$04 Score.
L $F165,$07,$0A

t $F1AB Messaging: High Score Name
@ $F1AB label=Messaging_HighScoreName
  $F1AB,$14
B $F1BF,$01 Terminator.

t $F1C0
B $F1C0,$01
B $F1C1,$02

t $F2D8 Messaging: Robotron Heroes
@ $F2D8 label=Messaging_RobotronHeroes
B $F2D8,$02 FLASH: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F2DA,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F2DC,$02 Select font: #N(#PEEK(#PC+$01)).
B $F2DE,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $F2E1,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F2E3,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
  $F2E5,$0F
B $F2F4,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F2F6,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F2F8,$01 Terminator.

c $F2F9

t $F38D Messaging: All Time Heroes
@ $F38D label=Messaging_AllTimeHeroes
B $F38D,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F38F,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $F392,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $F394,$0F
B $F3A3,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $F3A6,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F3A8,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
  $F3AA,$03
B $F3AD,$01 Terminator.

c $F3AE

t $F45A Messaging: Save / Load
@ $F45A label=Messaging_SaveLoad
B $F45A,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $F45D,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F45F,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F461,$02 Select font: #N(#PEEK(#PC+$01)).
  $F463,$24
B $F487,$01 Terminator.

c $F488

c $F4EC
  $F4EC,$03 Call #R$D070.
  $F4EF,$05 Call #R$D07E using #COLOUR$46.
  $F4F4,$03 Call #R$F83C.
  $F4F7,$03 Call #R$F637.
  $F4FA,$02 #REGa=#N$32.
  $F4FC,$03 Write #REGa to *#R$C4F8.
  $F4FF,$03 Call #R$ECE6.
  $F502,$03 Call #R$ECFB.
  $F505,$03 Call #R$ED10.
  $F508,$03 Call #R$ED71.
  $F50B,$03 Call #R$F7EE.
  $F50E,$03 Call #R$F51D.
  $F511,$03 Call #R$F5A0.
  $F514,$03 #REGa=*#R$C4F8.
  $F517,$01 Decrease #REGa by one.
  $F518,$02 Jump to #R$F4FC until #REGa is zero.
  $F51A,$03 Jump to #R$EBC8.

c $F51D

c $F5A0

c $F606

c $F637

t $F670 Messaging: Credits
@ $F670 label=Messaging_Credits
B $F670,$02 Select font: #N(#PEEK(#PC+$01)).
B $F672,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F674,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $F676,$02 FLASH: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F678,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F67A,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $F67D,$20
B $F69D,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F69F,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $F6A2,$20
B $F6C2,$01 Terminator.

c $F6C3

c $F76F XOR Blit Sprite
@ $F76F label=XorBlitSprite
D $F76F Takes the two-byte position entry at #REGhl (byte #N$00 = Y pixel row,
. byte #N$01 = X byte column) and the attribute byte in #REGe (shadow;
. bit 7 set = erase mode, bit 7 clear = draw mode). Computes each screen
. pixel address by reading the row base from the screen row LUT at #N$8C00
. (indexed by Y) and adding the X column byte offset stored in shadow #REGd.
. XORs #N$04 bytes of the fixed bitmap at #N$6CFC into consecutive screen pixel
. memory for each of #N$20 pixel rows (#N$04 attribute-cell rows of #N$08 pixel
. rows each). After the first pixel row of each attribute-cell row, derives the
. attribute memory high byte from the pixel address high byte and writes the
. attribute byte to #N$04 consecutive attribute cells — suppressed in erase mode.
R $F76F HL Pointer to the two-byte position entry (Y pixel row at +0, X byte column at +1)
N $F76F Initialise the bitmap source (#REGhl=#N$6CFC via EX DE,HL) and compute #REGix
. into the screen row LUT at #N$8C00, indexed by the Y pixel row. The row is
. shifted left into the LUT index directly (#REGix=#N$8C00 + Y × #N$02). Store
. the X column byte offset in shadow #REGd and set the outer loop count
. (#REGc=#N$04, shadow, one iteration per attribute-cell row of #N$08 pixel rows).
  $F76F,$03 #REGde=#N$6CFC (bitmap source base address; becomes #REGhl via EX DE,HL).
  $F772,$02 #REGb=#N$46 (initial high byte; becomes #N$8C or #N$8D after RL #REGb).
  $F774,$01 #REGc=Y pixel row (byte #N$00 of the position entry).
  $F775,$01 Advance #REGhl to byte #N$01 (X byte column).
  $F776,$02 SLA #REGc; carry = bit 7 of Y (selects high byte #N$8C or #N$8D).
  $F778,$02 RL #REGb; #REGb=#N$8C (or #N$8D if carry set) — high byte of LUT pointer.
  $F77A,$01 Stash #REGbc on the stack.
  $F77B,$01 #REGa=X byte column (byte #N$01 of the position entry).
  $F77C,$01 Switch to the shadow registers.
  $F77D,$01 #REGd=X byte column offset (held in shadow across all loop iterations).
  $F77E,$01 Switch back to the normal registers.
  $F77F,$02 POP #REGix; #REGix=#N$8C00 + Y × #N$02 (pointer into the screen row LUT).
  $F781,$01 #REGhl=#N$6CFC (bitmap source pointer); #REGde=old #REGhl (discarded).
  $F782,$01 Switch to the shadow registers.
  $F783,$02 #REGc=#N$04 (shadow, outer loop count: #N$04 attribute-cell rows).
  $F785,$01 Switch back to the normal registers.
@ $F786 label=XorBlitSprite_OuterLoop
N $F786 Outer loop (#N$04 iterations, one per attribute-cell row of #N$08 pixel rows).
. Compute the screen pixel address for the first row of this attribute cell:
. read shadow #REGd (X column), add the LUT low byte from *(#REGix) to give
. #REGe, then read the LUT high byte from *(#REGix+#N$01) into #REGd. Advance
. #REGix by two to the next LUT entry.
  $F786,$01 Switch to the shadow registers.
  $F787,$01 #REGa=#REGd (X byte column offset).
  $F788,$01 Switch back to the normal registers.
  $F789,$03 #REGa += *(#REGix) (LUT low byte); low byte of screen pixel address.
  $F78C,$02 Advance #REGix to the LUT high byte.
  $F78E,$01 #REGe=#REGa (low byte of screen pixel address).
  $F78F,$03 #REGd=*(#REGix) (high byte of screen pixel address from LUT).
  $F792,$02 Advance #REGix to the next LUT entry.
N $F794 XOR #N$04 consecutive bytes of the bitmap at (#REGhl)–(#REGhl+#N$03) into
. screen pixel memory at (#REGde)–(#REGde+#N$03), advancing both pointers.
  $F794,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F799,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F79E,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F7A3,$04 *(#REGde) ^= *(#REGhl); advance #REGhl.
N $F7A7 Derive the attribute memory address high byte from the current pixel address
. high byte in #REGd. Three right-rotations expose the screen-third index in
. bits #N$00–#N$01; OR with #N$58 gives the attribute area high byte (#N$58–#N$5B).
  $F7A7,$09 #REGd = (RRCA × #N$03 of #REGd) AND #N$03 OR #N$58 (attribute address high byte).
N $F7B0 Test the erase-mode flag (bit 7 of shadow #REGe). If set, skip writing
. the attribute byte so that the background colour is preserved during erase.
  $F7B0,$03 Switch to shadow; #REGa=#REGe (attribute byte); switch back.
  $F7B3,$02 Test bit 7 of #REGa (erase-mode flag).
  $F7B5,$02 If in erase mode, jump to #R$F7BE (skip attribute write).
  $F7B7,$07 Write attribute byte to (#REGde), (#REGde−#N$01), (#REGde−#N$02) and (#REGde−#N$03).
@ $F7BE label=XorBlitSprite_InnerSetup
  $F7BE,$04 Switch to shadow; #REGb=#N$07 (remaining pixel rows in this attribute-cell row); switch back.
@ $F7C2 label=XorBlitSprite_InnerLoop
N $F7C2 Inner loop (#N$07 iterations, one per remaining pixel row in this attribute-cell
. row). Compute the screen address from the LUT and XOR #N$04 bitmap bytes into
. pixel memory. No attribute write.
  $F7C2,$01 Switch to the shadow registers.
  $F7C3,$01 #REGa=#REGd (X byte column offset).
  $F7C4,$01 Switch back to the normal registers.
  $F7C5,$03 #REGa += *(#REGix) (LUT low byte for this pixel row).
  $F7C8,$02 Advance #REGix to the LUT high byte.
  $F7CA,$01 #REGe=#REGa (low byte of screen pixel address).
  $F7CB,$03 #REGd=*(#REGix) (high byte of screen pixel address from LUT).
  $F7CE,$02 Advance #REGix to the next LUT entry.
  $F7D0,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F7D5,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F7DA,$05 *(#REGde) ^= *(#REGhl); advance #REGde and #REGhl.
  $F7DF,$04 *(#REGde) ^= *(#REGhl); advance #REGhl.
  $F7E3,$03 Switch to shadow; decrement #REGb (inner pixel row counter); switch back.
  $F7E6,$02 Loop back to #R$F7C2 until all #N$07 pixel rows are blitted.
  $F7E8,$03 Switch to shadow; decrement #REGc (outer attribute-row counter); switch back.
  $F7EB,$02 Loop back to #R$F786 until all #N$04 attribute-cell rows are blitted.
  $F7ED,$01 Return.

c $F7EE Animate Intro Sprites
@ $F7EE label=AnimateIntroSprites
D $F7EE Iterates over the #N$18 three-byte entries in the sprite table at #R$F558
. (Y pixel row at +#N$00, X byte column at +#N$01, attribute byte at +#N$02) to
. animate the border march effect on the intro screen. For each entry, erases
. the sprite at its current position (calls #R$F76F with bit 7 of #REGe set
. in shadow to suppress attribute writes), advances the position by one step
. along a rectangular path (#N$08 pixel rows vertically or #N$01 byte column
. horizontally: right across Y=#N$00, down the right side at X=#N$1C, left
. across Y=#N$A0, up the left side at X=#N$00), then redraws the sprite at the
. new position (calls #R$F76F with bit 7 clear to write the attribute).
. Called once per frame by the attract mode loop at #R$F4EC.
  $F7EE,$02 #REGb=#N$18 (loop counter: #N$24 sprite entries).
  $F7F0,$03 #REGhl=#R$F558 (attribute byte position of the first entry).
@ $F7F3 label=AnimateIntroSprites_Loop
  $F7F3,$01 #REGa=attribute byte from the current entry.
  $F7F4,$05 Switch to shadow; #REGe=attribute byte; SET bit 7 (erase-mode flag for #R$F76F); switch back.
  $F7F9,$02 Back #REGhl two bytes to the Y pixel row (start of entry).
  $F7FB,$02 Stash #REGhl (entry start) and #REGbc on the stack.
  $F7FD,$03 Call #R$F76F to erase the sprite at its current position.
  $F800,$02 Restore #REGbc and #REGhl (entry start).
N $F802 Advance the sprite position by one step along the rectangular border path.
. Y pixel row is at *(#REGhl), X byte column at *(#REGhl+#N$01). Steps are
. #N$08 pixel rows vertically or #N$01 byte column horizontally. Wraps at
. X=#N$1C (right boundary, drop down a row) and Y=#N$A0 (bottom boundary,
. scroll left).
  $F802,$01 #REGa=#N$00.
  $F803,$03 If Y position (*#REGhl) = #N$00, jump to #R$F821 (top row: scroll X instead of Y).
  $F806,$03 Read X position (*(#REGhl+#N$01)) and compare with #N$00; restore #REGhl.
  $F809,$02 If X!=#N$00, jump to #R$F811.
  $F80B,$06 Y −= #N$08 (on left side, scroll up); jump to #R$F829.
@ $F811 label=AnimateIntroSprites_CheckBoundary
  $F811,$03 #REGa=#N$A0; compare with Y position.
  $F814,$02 If Y!=#N$A0, jump to #R$F81B (not at bottom boundary, scroll down).
  $F816,$04 X−− (at bottom boundary, scroll left); jump to #R$F828.
@ $F81A label=AnimateIntroSprites_DropRow
  $F81A,$01 Back #REGhl to the Y byte.
@ $F81B label=AnimateIntroSprites_ScrollDown
  $F81B,$06 Y += #N$08 (scroll down); jump to #R$F829.
@ $F821 label=AnimateIntroSprites_ScrollX
N $F821 Top row (Y=#N$00): if X has reached the right boundary (#N$1C), drop a row
. (Y+=#N$08); otherwise scroll right (X++).
  $F821,$06 Read X (*(#REGhl+#N$01)); if X=#N$1C jump to #R$F81A (drop a row); otherwise X++.
  $F827,$01 X++ (scroll right).
@ $F828 label=AnimateIntroSprites_RestoreHL
  $F828,$01 Restore #REGhl to the Y byte position.
@ $F829 label=AnimateIntroSprites_Draw
  $F829,$02 Stash #REGhl (entry start) and #REGbc on the stack.
  $F82B,$04 Switch to shadow; RES bit 7 of #REGe (clear erase-mode flag for draw pass); switch back.
  $F82F,$03 Call #R$F76F to draw the sprite at the updated position.
  $F832,$02 Restore #REGbc and #REGhl (entry start).
  $F834,$05 Advance #REGhl by #N$05 to the attribute byte of the next entry.
  $F839,$02 Decrease counter and loop back to #R$F7F3.
  $F83B,$01 Return.

c $F83C Draw Intro Sprites
@ $F83C label=DrawIntroSprites
D $F83C Iterates over the #N$18 three-byte entries in the sprite table at #R$F558
. (Y pixel row at +#N$00, X byte column at +#N$01, attribute byte at +#N$02),
. calling #R$F76F once per entry to draw each sprite in its initial position.
. Called once during attract-mode setup at #R$F4EC before the animation loop
. begins.
  $F83C,$02 #REGb=#N$18 (loop counter: #N$24 sprite entries).
  $F83E,$03 #REGhl=#R$F558 (attribute byte position of the first entry).
@ $F841 label=DrawIntroSprites_Loop
  $F841,$01 #REGa=attribute byte from the current entry.
  $F842,$01 Switch to the shadow registers.
  $F843,$01 #REGe=attribute byte (passed to #R$F76F as the draw-mode attribute).
  $F844,$01 Switch back to the normal registers.
  $F845,$02 Stash #REGbc and #REGhl on the stack.
  $F847,$02 Back #REGhl two bytes to the Y pixel row (start of entry).
  $F849,$03 Call #R$F76F to draw the sprite at the position held in the current entry.
  $F84C,$02 Restore #REGhl and #REGbc from the stack.
  $F84E,$03 Advance #REGhl by three to the attribute byte of the next entry.
  $F851,$02 Decrease counter and loop back to #R$F841.
  $F853,$01 Return.

g $F854

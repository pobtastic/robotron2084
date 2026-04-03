; Copyright Atarisoft (UK) 1984, 2025 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Robotron: 2084 Loading Screen. } { #SCR$02(loading) } UDGTABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

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
  $8007,$01 Flags; bit #N$00 = control code parameter was out of range.

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
. (FLASH) control code. Sets or clears bit #N$07 of the attribute byte at #R$8004.
  $8E52,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E54,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E57,$02 Test bit #N$00 of the masked parameter.
  $8E59,$02 If the parameter is #N$00, jump to #R$8E60 to clear FLASH.
  $8E5B,$04 Set the FLASH bit (#N$07) of the attribute byte at #R$8004.
  $8E5F,$01 Return.
@ $8E60 label=PrintHandler_Flash_Off
  $8E60,$04 Clear the FLASH bit (#N$07) of the attribute byte at #N$8004.
  $8E64,$01 Return.
@ $8E65 label=PrintHandler_Bright
N $8E65 Set BRIGHT parameter handler. Called on the byte immediately following a #N$13
. (BRIGHT) control code. Sets or clears bit #N$06 of the attribute byte at #N$8004.
  $8E65,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E67,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E6A,$02 Test bit #N$00 of the masked parameter.
  $8E6C,$02 If the parameter is #N$00, jump to #R$8E73 to clear BRIGHT.
  $8E6E,$04 Set the BRIGHT bit (#N$06) of the attribute byte at #N$8004.
  $8E72,$01 Return.
@ $8E73 label=PrintHandler_Bright_Off
  $8E73,$04 Clear the BRIGHT bit (#N$06) of the attribute byte at #N$8004.
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
  $8EBD,$04 Set the wrap flag (bit #N$00 of *#N$8007).
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
  $8EEF,$04 Otherwise set the out-of-range flag (bit #N$00 of *#N$8007).
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

c $C400 Game Entry Point Alias
@ $C400 label=GameEntryPointAlias
  $C400,$03 Jump to #R$EBBC.

c $D070 Clear Screen Buffer
@ $D070 label=ClearScreenBuffer
  $D070,$0D Clear #N$1800 bytes of data from #R$4000(#N$4000) to #N$5B00.
  $D07D,$01 Return.

c $D07E

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

c $ECE6

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

c $F0EE

c $F4EC
  $F4EC,$03 Call #R$D070.
  $F4EF,$02 #REGa=#COLOUR$46.
  $F4F1,$03 Call #R$D07E.
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

c $F76F

c $F7EE

c $F83C
  $F83C,$02 #REGb=#N$18.
  $F83E,$03 #REGhl=#R$F558.
  $F841,$01 #REGa=*#REGhl.
  $F842,$01 Switch to the shadow registers.
  $F843,$01 #REGe=#REGa.
  $F844,$01 Switch back to the normal registers.
  $F845,$02 Stash #REGbc and #REGhl on the stack.
  $F847,$02 Decrease #REGhl by two.
  $F849,$03 Call #R$F76F.
  $F84C,$02 Restore #REGhl and #REGbc from the stack.
  $F84E,$03 Increment #REGhl by three.
  $F851,$02 Decrease counter by one and loop back to #R$F841 until counter is zero.
  $F853,$01 Return.

g $F854

; Copyright Atarisoft (UK) 1984, 2025 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
> $4000 @expand=#DEF(#POKE()(a) #LINK(Pokes#$a))
b $4000 Loading Screen
@ $4000 label=Loading
D $4000 #UDGTABLE { =h Robotron: 2084 Loading Screen. } { #SCR$02(loading) } UDGTABLE#
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

g $6000 Entity List
@ $6000 label=Entity_List
D $6000 Start of the entity list in RAM. The playfield write pointer at
. #R$C4D1 is reset to this address before the main game loop, and the
. entity processing routines walk forward from here each frame.

g $6100 Entity List Base
@ $6100 label=Entity_List_Base
D $6100 Base address of the entity list. #R$C509, #R$C50B, and #R$C50D are
. all initialised to this address. Also used as the score table reception
. buffer during tape load operations at #R$ED2B.

g $6D7D

b $7500 Entity Sprite: Enforcer
@ $7500 label=Graphics_Enforcer_Up
D $7500 Wide entity sprite pixel data for the Enforcer. Eight frames of
. #N$18 bytes each (#N$0C rows of #N$02 pixel bytes per row) per
. direction. Referenced by #R$C60C.
  $7500,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7500)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(enforcer-up-#EVAL($01+(#PC-$7500)/$18)) }
. TABLE#
L $7500,$18,$08,$02
@ $75C0 label=Graphics_Enforcer_Right
  $75C0,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$75C0)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(enforcer-right-#EVAL($01+(#PC-$75C0)/$18)) }
. TABLE#
L $75C0,$18,$08,$02
@ $7680 label=Graphics_Enforcer_Down
  $7680,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7680)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(enforcer-down-#EVAL($01+(#PC-$7680)/$18)) }
. TABLE#
L $7680,$18,$08,$02
@ $7740 label=Graphics_Enforcer_Left
  $7740,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7740)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(enforcer-left-#EVAL($01+(#PC-$7740)/$18)) }
. TABLE#
L $7740,$18,$08,$02

b $7A00 Entity Sprite: Blank 1
@ $7A00 label=Graphics_Blank1_Down
D $7A00 Wide entity sprite pixel data (Blank 1). Eight frames of #N$30
. bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced by
. #R$C60C.
  $7A00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7A00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank1-down-#EVAL($01+(#PC-$7A00)/$30)) }
. TABLE#
L $7A00,$30,$08,$02
@ $7B80 label=Graphics_Blank1_Right
  $7B80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7B80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank1-right-#EVAL($01+(#PC-$7B80)/$30)) }
. TABLE#
L $7B80,$30,$08,$02
@ $7D00 label=Graphics_Blank1_Left
  $7D00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7D00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank1-left-#EVAL($01+(#PC-$7D00)/$30)) }
. TABLE#
L $7D00,$30,$08,$02
@ $7E80 label=Graphics_Blank1_Up
  $7E80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$7E80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank1-up-#EVAL($01+(#PC-$7E80)/$30)) }
. TABLE#
L $7E80,$30,$08,$02

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

b $8700 Entity Sprite: Points
@ $8700 label=Graphics_Points_1000
D $8700 Sprite pixel data for Points graphics. Eight frames of #N$18
. bytes each (#N$0C rows of #N$02 pixel bytes per row) per value.
. Referenced by #R$C60C.
  $8700,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$8700)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(points-1000-#EVAL($01+(#PC-$8700)/$18)) }
. TABLE#
L $8700,$18,$08,$02
@ $87C0 label=Graphics_Points_2000
  $87C0,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$87C0)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(points-2000-#EVAL($01+(#PC-$87C0)/$18)) }
. TABLE#
L $87C0,$18,$08,$02
@ $8880 label=Graphics_Points_3000
  $8880,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$8880)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(points-3000-#EVAL($01+(#PC-$8880)/$18)) }
. TABLE#
L $8880,$18,$08,$02
@ $8940 label=Graphics_Points_4000
  $8940,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$8940)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(points-4000-#EVAL($01+(#PC-$8940)/$18)) }
. TABLE#
L $8940,$18,$08,$02

b $8A00 Column Pixel Lookup Table
@ $8A00 label=Column_Pixel_Lookup_Table
D $8A00 #N$100 two-byte entries built by #R$9010: each pair is the byte offset
. within the scan line and the bit mask for pixel columns #N$00-#N$FF.
B $8A00,$200,$02

b $8C00 Screen Row Address Lookup Table
@ $8C00 label=Screen_Row_Address_Lookup_Table
D $8C00 Low/high byte pairs for bitmap scan-line bases in screen memory (#N$4000). Used
. with #R$8A00 when plotting character cells (#R$8D80). Written by #R$9010.
B $8C00,$180,$02

c $8D80 Plot Screen Pixel
@ $8D80 label=PlotCharacterCell_Draw
D $8D80 Renders one pixel at screen position (#REGh = pixel column, #REGl =
. pixel row). Derives the column byte offset and pixel mask by indexing
. into #R$8A00, and reads the screen scan-line address from #R$8C00.
. Three entry points: #R$8D80 draws by setting bits, #R$8D99 erases by
. clearing bits, #R$8DB3 toggles bits.
R $8D80 H Pixel column
R $8D80 L Pixel row
  $8D80,$07 Compute the column entry address in #R$8A00.
  $8D87,$06 Compute the row entry address in #R$8C00.
  $8D8D,$04 Read the scan-line base address from #R$8C00.
  $8D91,$04 Apply the column byte offset from #R$8A00 to the scan-line
. address and advance to the pixel mask.
  $8D95,$03 Set the pixel on screen by ORing the column mask.
  $8D98,$01 Return.
N $8D99 Alternate entry: erase the pixel by inverting the column mask
. and clearing the matching bits on screen.
@ $8D99 label=PlotCharacterCell_Erase
  $8D99,$07 Compute the column entry address in #R$8A00.
  $8DA0,$06 Compute the row entry address in #R$8C00.
  $8DA6,$04 Read the scan-line base address from #R$8C00.
  $8DAA,$04 Apply the column byte offset from #R$8A00 to the scan-line
. address and advance to the pixel mask.
  $8DAE,$04 Invert the column mask and clear the matching bits on screen.
  $8DB2,$01 Return.
N $8DB3 Alternate entry: toggle the pixel by flipping the matching bits
. using the column mask.
@ $8DB3 label=PlotCharacterCell_Toggle
  $8DB3,$07 Compute the column entry address in #R$8A00.
  $8DBA,$06 Compute the row entry address in #R$8C00.
  $8DC0,$04 Read the scan-line base address from #R$8C00.
  $8DC4,$04 Apply the column byte offset from #R$8A00 to the scan-line
. address and advance to the pixel mask.
  $8DC8,$03 Toggle the matching bits on screen using the column mask.
  $8DCB,$01 Return.

c $8DCC Print Dispatch
@ $8DCC label=PrintDispatch
D $8DCC Calls the active print handler stored at #R$800A to process one
. character or control code, preserving caller context across the call.
  $8DCC,$01 Stash #REGbc on the stack.
  $8DCD,$01 Switch to the shadow registers.
  $8DCE,$03 Stash #REGhl and #REGix on the stack.
  $8DD1,$04 Set #REGix to the print state base at #R$8000.
  $8DD5,$04 Push #R$8DDD as the handler return address.
  $8DD9,$03 Read the current print handler address from #R$800A.
  $8DDC,$01 Jump to the print handler.

c $8DDD Print Dispatch Return
@ $8DDD label=Print_Dispatch_Return
D $8DDD Return point reached after the dispatched print handler completes.
. Restores #REGix and #REGhl from the stack, switches back to the
. normal registers, restores #REGbc, and returns to the caller.
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

c $8E0F Print Handler: Newline
@ $8E0F label=PrintHandler_Newline
D $8E0F Carriage return handler: resets the X position to the left margin, then advances
. the Y position by one font line height (wrapping at #N$BC).
  $8E0F,$03 #REGhl=#R$8001 (X position pointer).
  $8E12,$04 Write *#R$8005 (left margin X position) to *#REGhl, resetting X to
. the left margin.
  $8E16,$01 #REGhl=#R$8000 (Y position pointer).
@ $8E17 label=PrintHandler_AdvanceRow
  $8E17,$04 #REGa=*#REGhl + font line height (*#R$8010).
  $8E1B,$04 Wrap the Y position at #N$BC if it has reached or exceeded that value.
  $8E1F,$02 Subtract #N$BC to wrap Y.
@ $8E21 label=PrintHandler_AdvanceRow_Store
  $8E21,$01 Write the new Y position back to *#REGhl.
  $8E22,$01 Return.

c $8E23 Print Handler: Unsupported
@ $8E23 label=PrintHandler_Unsupported
D $8E23 Parameter handler for unsupported control codes #N$14 and #N$15. Consumes the
. parameter byte by resetting #R$800A to the default handler, then falls through to
. #R$8E29 to print a "#CHR$3F" (#N$3F) placeholder.
  $8E23,$06 Reset #R$800A to #R$8DE3 (default handler).
@ $8E29 label=PrintHandler_Invalid
  $8E29,$02 Replace the byte with #N$3F ("#CHR$3F").
  $8E2B,$03 Jump to #R$8EF7 to render the character.

c $8E2E Print Handler: Ink
@ $8E2E label=PrintHandler_Ink
D $8E2E Sets the INK colour parameter handler. Called on the byte immediately
. following a #N$10 (INK) control code.
. Masks the parameter to the lower three bits (colour #N$00–#N$07) and writes
. it into the INK bits (0–2) of the attribute byte at #R$8004.
  $8E2E,$02 #REGb=#N$08 (mask limit for INK colour range #N$00–#N$07).
  $8E30,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to the colour value.
  $8E33,$03 #REGa=*#R$8004 (current attribute byte).
  $8E36,$02,b$01 Clear the INK bits (#N$F8 = keep PAPER, BRIGHT, FLASH).
  $8E38,$01 Write the new INK colour into bits 0–2.
  $8E39,$03 Write the updated attribute byte back to *#R$8004.
  $8E3C,$01 Return.

c $8E3D Print Handler: Paper
@ $8E3D label=PrintHandler_Paper
D $8E3D Set PAPER colour parameter handler. Called on the byte immediately following a
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

c $8E52 Print Handler: Flash
@ $8E52 label=PrintHandler_Flash
D $8E52 Set FLASH parameter handler. Called on the byte immediately following a #N$12
. (FLASH) control code. Sets or clears bit 7 of the attribute byte at #R$8004.
  $8E52,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E54,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E57,$02 Test bit 0 of the masked parameter.
  $8E59,$02 If the parameter is #N$00, jump to #R$8E60 to clear FLASH.
  $8E5B,$04 Set the FLASH bit (7) of the attribute byte at #R$8004.
  $8E5F,$01 Return.
N $8E60 Handle turning FLASH off.
@ $8E60 label=PrintHandler_Flash_Off
  $8E60,$04 Clear the FLASH bit (7) of the attribute byte at #N$8004.
  $8E64,$01 Return.

c $8E65 Print Handler: Bright
@ $8E65 label=PrintHandler_Bright
D $8E65 Set BRIGHT parameter handler. Called on the byte immediately following a #N$13
. (BRIGHT) control code. Sets or clears bit 6 of the attribute byte at #N$8004.
  $8E65,$02 #REGb=#N$02 (mask limit: parameter is #N$00 or #N$01).
  $8E67,$03 Call #R$8EE6 to reset #R$800A and mask #REGb to #N$00 or #N$01.
  $8E6A,$02 Test bit 0 of the masked parameter.
  $8E6C,$02 If the parameter is #N$00, jump to #R$8E73 to clear BRIGHT.
  $8E6E,$04 Set the BRIGHT bit (6) of the attribute byte at #N$8004.
  $8E72,$01 Return.
N $8E73 Handle turning BRIGHT off.
@ $8E73 label=PrintHandler_Bright_Off
  $8E73,$04 Clear the BRIGHT bit (6) of the attribute byte at #N$8004.
  $8E77,$01 Return.

c $8E78 Print Handler: Print At X
@ $8E78 label=PrintHandler_PrintAt_X
D $8E78 PRINT AT first parameter handler. Called on the byte immediately following a
. #N$16 (PRINT AT) control code. Stores the X (column) parameter to #N$8001 and
. installs #R$8E82 into #R$800A to handle the next byte (the Y position).
  $8E78,$03 Write the X column parameter to *#R$8001.
  $8E7B,$06 Write #R$8E82 (Y position parameter handler) to #R$800A to consume
. the next (Y) byte.
  $8E81,$01 Return.

c $8E82 Print Handler: Print At Y
@ $8E82 label=PrintHandler_PrintAt_Y
D $8E82 PRINT AT second parameter handler. Called on the byte immediately following the
. X parameter. Wraps the Y (row) parameter at #N$BC and stores it to #N$8000 before
. restoring the default handler.
  $8E82,$06 Reset #R$800A to #R$8DE3 (default handler).
  $8E88,$04 If the Y parameter is less than #N$BC, jump to #R$8E8E.
  $8E8C,$02 Subtract #N$BC to wrap the Y position.
@ $8E8E label=PrintHandler_PrintAt_Y_Store
  $8E8E,$03 Write the Y position to *#R$8000.
  $8E91,$01 Return.

c $8E92 Print Handler: Tab
@ $8E92 label=PrintHandler_Tab
D $8E92 TAB parameter handler. Called on the byte immediately following a #N$17 (TAB)
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

c $8EAA Print Handler: Left Margin
@ $8EAA label=PrintHandler_LeftMargin
D $8EAA Left margin parameter handler. Called on the byte immediately following a #N$18
. control code. Sets the left margin X position at #N$8005 to the lower six bits of
. the parameter.
  $8EAA,$02 #REGb=#N$40 (mask limit: lower six bits, #N$00–#N$3F).
  $8EAC,$03 Call #R$8EE6 to reset #R$800A and mask #REGa to the lower six bits.
  $8EAF,$03 Write the masked parameter to *#R$8005 (left margin X position).
  $8EB2,$01 Return.

c $8EB3 Print Handler: Right Margin
@ $8EB3 label=PrintHandler_RightMargin
D $8EB3 Right margin parameter handler. Called on the byte immediately following a #N$19
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

c $8EC7 Print Handler: Select Font
@ $8EC7 label=PrintHandler_SelectFont
D $8EC7 Select font parameter handler. Called on the byte immediately following a #N$1A
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

c $8EE6 Print Handler: Mask Parameter
@ $8EE6 label=PrintHandler_MaskParam
D $8EE6 Parameter mask and validation utility. Called by control code parameter handlers
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

c $8EF7 Print Handler: Render
@ $8EF7 label=PrintHandler_Render
D $8EF7 Character renderer. Determines the pixel width of the character, checks whether
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
. pixel positions. The screen row address lookup table (indexed by Y) provides the base pixel
. row address; three right-shifts of X derive the column byte offset and the
. within-byte pixel shift (0–7 bits).
  $8F28,$01 #REGa=character width.
  $8F29,$01 Stash character width in #REGa'.
  $8F2A,$03 #REGa=*#R$8000 (Y pixel position).
  $8F2D,$07 #REGhl=screen row address lookup table entry for pixel row Y (#N$8C00 + Y × #N$02).
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
  $8F54,$09 Read each two-byte screen row address from the lookup table into the workspace at
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

c $9010 Initialise Print Tables
@ $9010 label=InitialisePrintTables
D $9010 Builds two lookup tables used by the print engine: the column pixel table
. at #R$8A00 (#N$100 two-byte entries mapping each pixel column to a scan-line
. byte offset and bit mask) and the row address table at #N$8C00 (#N$60 entries
. mapping pixel rows to scan-line base screen addresses).
  $9010,$03 #REGhl=#R$8A00 (start of the column lookup table).
  $9013,$02 #REGc=#N$80 (bit mask seed).
  $9015,$01 #REGa=#N$00 (initial byte offset).
@ $9016 label=InitialisePrintTables_ColLookupLoop
N $9016 Each entry is two bytes: the byte offset within the scan line, and the bit
. mask for that pixel column. Indices #N$00-#N$FF, written to #R$8A00.
  $9016,$04 Write the column lookup table entry: byte offset (#REGa) and bit mask (#REGc).
  $901A,$04 Rotate the bit mask right (#REGc) with carry advancing the byte offset (#REGa).
  $901E,$04 Loop back to #R$9016 until all #N$100 column lookup table entries are built.
  $9022,$02 #REGa=#N$40 (initial screen row high byte).
  $9024,$03 #REGbc=#N$2000 (#REGb=#N$20 row stride, #REGc=#N$20 initial low byte).
  $9027,$03 #REGde=#N$4048 (#REGd=#N$40 base, #REGe=#N$48 inner loop endpoint).
@ $902A label=InitialisePrintTables_RowLookupLoop
N $902A Scan-line base addresses, low byte then high byte, written to #N$8C00.
. The loop sweeps #N$60 entries covering the full screen height.
  $902A,$04 Write the row lookup table entry (low byte #REGc, high byte #REGa).
  $902E,$04 Increment the high byte and loop back to #R$902A while less than #REGe.
  $9032,$03 Advance the row low byte by the stride.
  $9035,$01 #REGa=#REGd (reload the high-byte base for the next inner pass).
  $9036,$02 Loop back to #R$902A while the row low byte is non-zero.
  $9038,$01 #REGd=#REGe (save the current row endpoint).
  $9039,$03 Compute the next endpoint as #REGe + #N$08 into #REGa.
  $903C,$02 Compare the endpoint with #N$60.
@ $903E label=InitialisePrintTables_RowLookupDone
  $903E,$02 Jump to #R$9044 if all rows are built.
  $9040,$01 #REGe=#REGa (update the inner loop endpoint).
  $9041,$01 #REGa=#REGd (reload the high-byte base for the inner loop).
  $9042,$02 Jump back to #R$902A.

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

b $9100 Entity Sprite: Player
@ $9100 label=Graphics_Player_Down
D $9100 Wide entity sprite pixel data for the Player. Eight frames of
. #N$18 bytes each (#N$0C rows of #N$02 pixel bytes per row) per
. direction. Referenced by #R$C60C.
  $9100,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9100)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(player-down-#EVAL($01+(#PC-$9100)/$18)) }
. TABLE#
L $9100,$18,$08,$02
@ $91C0 label=Graphics_Player_Right
  $91C0,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$91C0)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(player-right-#EVAL($01+(#PC-$91C0)/$18)) }
. TABLE#
L $91C0,$18,$08,$02
@ $9280 label=Graphics_Player_Left
  $9280,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9280)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(player-left-#EVAL($01+(#PC-$9280)/$18)) }
. TABLE#
L $9280,$18,$08,$02
@ $9340 label=Graphics_Player_Up
  $9340,$18,$02 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9340)/$18) }
.   { #UDGARRAY$02,attr=$47,scale=$04,step=$02((#PC)-(#PC+$17)-$01-$10){$00,$00,$40,$2C}(player-up-#EVAL($01+(#PC-$9340)/$18)) }
. TABLE#
L $9340,$18,$08,$02

b $9400 Entity Sprite: Mommy
@ $9400 label=Graphics_Mommy_Up
D $9400 Wide entity sprite pixel data for Mommy. Eight frames of #N$30
. bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced by
. #R$C60C.
  $9400,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9400)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mommy-up-#EVAL($01+(#PC-$9400)/$30)) }
. TABLE#
L $9400,$30,$08,$02
@ $9580 label=Graphics_Mommy_Right
  $9580,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9580)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mommy-right-#EVAL($01+(#PC-$9580)/$30)) }
. TABLE#
L $9580,$30,$08,$02
@ $9700 label=Graphics_Mommy_Down
  $9700,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9700)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mommy-down-#EVAL($01+(#PC-$9700)/$30)) }
. TABLE#
L $9700,$30,$08,$02
@ $9880 label=Graphics_Mommy_Left
  $9880,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9880)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mommy-up-#EVAL($01+(#PC-$9880)/$30)) }
. TABLE#
L $9880,$30,$08,$02

b $9A00 Entity Sprite: Daddy
@ $9A00 label=Graphics_Daddy_Up
D $9A00 Wide entity sprite pixel data for Daddy. Eight frames of #N$30
. bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced by
. #R$C60C.
  $9A00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9A00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(daddy-up-#EVAL($01+(#PC-$9A00)/$30)) }
. TABLE#
L $9A00,$30,$08,$02
@ $9B80 label=Graphics_Daddy_Right
  $9B80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9B80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(daddy-right-#EVAL($01+(#PC-$9B80)/$30)) }
. TABLE#
L $9B80,$30,$08,$02
@ $9D00 label=Graphics_Daddy_Down
  $9D00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9D00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(daddy-down-#EVAL($01+(#PC-$9D00)/$30)) }
. TABLE#
L $9D00,$30,$08,$02
@ $9E80 label=Graphics_Daddy_Left
  $9E80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$9E80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(daddy-left-#EVAL($01+(#PC-$9E80)/$30)) }
. TABLE#
L $9E80,$30,$08,$02

b $A000 Entity Sprite: Mikey
@ $A000 label=Graphics_Mikey_Up
D $A000 Wide entity sprite pixel data for Mikey. Eight frames of #N$30
. bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced by
. #R$C60C.
  $A000,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A000)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mikey-up-#EVAL($01+(#PC-$A000)/$30)) }
. TABLE#
L $A000,$30,$08,$02
@ $A180 label=Graphics_Mikey_Right
  $A180,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A180)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mikey-right-#EVAL($01+(#PC-$A180)/$30)) }
. TABLE#
L $A180,$30,$08,$02
@ $A300 label=Graphics_Mikey_Down
  $A300,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A300)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mikey-down-#EVAL($01+(#PC-$A300)/$30)) }
. TABLE#
L $A300,$30,$08,$02
@ $A480 label=Graphics_Mikey_Left
  $A480,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A480)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(mikey-left-#EVAL($01+(#PC-$A480)/$30)) }
. TABLE#
L $A480,$30,$08,$02

b $A600 Entity Sprite: Hulk
@ $A600 label=Graphics_Hulk_Up
D $A600 Wide entity sprite pixel data for the Hulk. Eight frames of
. #N$30 bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced
. by #R$C60C.
  $A600,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A600)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(hulk-up-#EVAL($01+(#PC-$A600)/$30)) }
. TABLE#
L $A600,$30,$08,$02
@ $A780 label=Graphics_Hulk_Right
  $A780,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A780)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(hulk-right-#EVAL($01+(#PC-$A780)/$30)) }
. TABLE#
L $A780,$30,$08,$02
@ $A900 label=Graphics_Hulk_Down
  $A900,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$A900)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(hulk-down-#EVAL($01+(#PC-$A900)/$30)) }
. TABLE#
L $A900,$30,$08,$02
@ $AA80 label=Graphics_Hulk_Left
  $AA80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$AA80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(hulk-left-#EVAL($01+(#PC-$AA80)/$30)) }
. TABLE#
L $AA80,$30,$08,$02

b $AC00 Entity Sprite: Enforcer Bullets
@ $AC00 label=Graphics_Enforcer_Bullet
D $AC00 Wide entity sprite pixel data for the Enforcer Bullet. Eight
. frames of #N$30 bytes each (#N$10 rows of #N$03 pixel bytes per row).
. Referenced by #R$C60C.
  $AC00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$AC00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(enforcer-bullet-#EVAL($01+(#PC-$AC00)/$30)) }
. TABLE#
L $AC00,$30,$08,$02

b $AD80 Entity Sprite: Spheroid
@ $AD80 label=Graphics_Spheroid_1
D $AD80 Wide entity sprite pixel data for the Spheroid. Five animation
. state entries of eight frames (#N$30 bytes each, #N$10 rows of #N$03
. pixel bytes per row). Referenced by #R$C60C.
  $AD80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$AD80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(spheroid-1-#EVAL($01+(#PC-$AD80)/$30)) }
. TABLE#
L $AD80,$30,$08,$02
@ $AF00 label=Graphics_Spheroid_2
  $AF00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$AF00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(spheroid-2-#EVAL($01+(#PC-$AF00)/$30)) }
. TABLE#
L $AF00,$30,$08,$02
@ $B080 label=Graphics_Spheroid_3
  $B080,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B080)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(spheroid-3-#EVAL($01+(#PC-$B080)/$30)) }
. TABLE#
L $B080,$30,$08,$02
@ $B200 label=Graphics_Spheroid_4
  $B200,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B200)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(spheroid-4-#EVAL($01+(#PC-$B200)/$30)) }
. TABLE#
L $B200,$30,$08,$02
@ $B380 label=Graphics_Spheroid_5
  $B380,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B380)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(spheroid-5-#EVAL($01+(#PC-$B380)/$30)) }
. TABLE#
L $B380,$30,$08,$02

b $B500 Entity Sprite: Test
@ $B500 label=Graphics_Test_B500_Down
D $B500 Wide entity sprite pixel data (identity unknown). Eight frames of
. #N$30 bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced
. by #R$C60C.
  $B500,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B500)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(test-b500-down-#EVAL($01+(#PC-$B500)/$30)) }
. TABLE#
L $B500,$30,$08,$02
@ $B680 label=Graphics_Test_B500_Up
  $B680,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B680)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(test-b500-up-#EVAL($01+(#PC-$B680)/$30)) }
. TABLE#
L $B680,$30,$08,$02

b $B800 Entity Sprite: Brain
@ $B800 label=Graphics_Brain_Up
D $B800 Wide entity sprite pixel data for the Brain. Eight frames of
. #N$30 bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced
. by #R$C60C.
  $B800,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B800)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(brain-up-#EVAL($01+(#PC-$B800)/$30)) }
. TABLE#
L $B800,$30,$08,$02
@ $B980 label=Graphics_Brain_Right
  $B980,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$B980)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(brain-right-#EVAL($01+(#PC-$B980)/$30)) }
. TABLE#
L $B980,$30,$08,$02
@ $BB00 label=Graphics_Brain_Down
  $BB00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$BB00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(brain-down-#EVAL($01+(#PC-$BB00)/$30)) }
. TABLE#
L $BB00,$30,$08,$02
@ $BC80 label=Graphics_Brain_Left
  $BC80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$BC80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(brain-left-#EVAL($01+(#PC-$BC80)/$30)) }
. TABLE#
L $BC80,$30,$08,$02

b $BE00 Entity Sprite: Blank 2
@ $BE00 label=Graphics_Blank2_Down
D $BE00 Wide entity sprite pixel data (Blank 2). Eight frames of #N$30
. bytes each (#N$10 rows of #N$03 pixel bytes per row). Referenced by
. #R$C60C.
  $BE00,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$BE00)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank2-down-#EVAL($01+(#PC-$BE00)/$30)) }
. TABLE#
L $BE00,$30,$08,$02
@ $BF80 label=Graphics_Blank2_Right
  $BF80,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$BF80)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank2-right-#EVAL($01+(#PC-$BF80)/$30)) }
. TABLE#
L $BF80,$30,$08,$02
@ $C100 label=Graphics_Blank2_Left
  $C100,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$C100)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank2-left-#EVAL($01+(#PC-$C100)/$30)) }
. TABLE#
L $C100,$30,$08,$02
@ $C280 label=Graphics_Blank2_Up
  $C280,$30,$03 #UDGTABLE
.   { =h Frame: #N($01+(#PC-$C280)/$30) }
.   { #UDGARRAY$03,attr=$47,scale=$04,step=$03((#PC)-(#PC+$2F)-$01-$18)(blank2-up-#EVAL($01+(#PC-$C280)/$30)) }
. TABLE#
L $C280,$30,$08,$02

c $C400 Game Entry Point Alias
@ $C400 label=GameEntryPointAlias
  $C400,$03 Jump to #R$EBBC.

g $C403 Player 1 State
@ $C403 label=Player_1_State
D $C403 Root of the active player state block (see #R$D08B / #R$D44B). Leading
. bytes hold the packed score for #R$C544 and the prefix compared in #R$C5C1.
B $C403,$05,$01

g $C408 Wave Number
@ $C408 label=WaveNumber

g $C409 Wave Definition Pointer
@ $C409 label=Wave_Definition_Pointer
D $C409 Pointer to the current entry in the wave definition table. Read by #R$D24C
. to load the enemy count and type for the incoming wave; advanced after each
. wave is staged.
W $C409,$02

g $C414
B $C414,$01

g $C415 Lives
@ $C415 label=Lives
B $C415,$01

g $C416 Wave
@ $C416 label=Wave
B $C416,$01

g $C417 Lives Display Vertical Step
@ $C417 label=Lives_Display_Vertical_Step
D $C417 Vertical pixel stride between adjacent life icons in #R$C794. Each
. pass advances the vertical seed by this value (#N$06) to space icons
. evenly in the lives display column.
B $C417,$01

g $C418 Extra Life Compare Byte 0
@ $C418 label=ExtraLifeCompare_b0
D $C418 First byte of the four-byte template compared with *#R$C403 in #R$C5C1.
B $C418,$01

g $C419 Extra Life Compare Byte 1
@ $C419 label=ExtraLifeCompare_b1
D $C419 Second template byte vs *#R$C404 in #R$C5C1. Also the BCD byte that
. #R$C5C1 adds #N$02 to (carry into *#R$C415). Seeded as #N$02 in #R$D45F.
B $C419,$01

g $C41A Extra Life Compare Byte 2
@ $C41A label=ExtraLifeCompare_b2
D $C41A Third template byte, compared with *#R$C405 in #R$C5C1.
B $C41A,$01

g $C41B Extra Life Compare Byte 3
@ $C41B label=ExtraLifeCompare_b3
D $C41B Fourth template byte, compared with *#R$C406 in #R$C5C1.
B $C41B,$01

g $C41C Active Enemy Count
@ $C41C label=Active_Enemy_Count
D $C41C Running total of active wave enemies. Incremented as enemies are spawned
. and decremented as they are killed. When it reaches zero, #R$D24C loads a
. fresh wave; when non-zero, the current wave set is re-populated instead.
. #R$C5EF also reads it as a session-active gate: non-zero means a game is
. in progress, so the copy-protection keyboard check is run.
B $C41C,$01

g $C41D Wave Display X Pixel Position
@ $C41D label=WaveDisplay_X_PixelPosition

g $C41E Two-Player Session Flag
@ $C41E label=TwoPlayerSessionFlag
D $C41E Non-zero when both player slots take part in the current credit session.
. After a lost life #R$D367 uses it for #R$D08B swap vs same-player loop.
. Cleared on init after the max wave.
B $C41E,$01
@ $C420 label=Colour_Bar_Column
B $C420,$01

g $C423 Wave Enemy Count
@ $C423 label=Wave_Enemy_Count
D $C423 Number of primary wave enemies to spawn in the current wave. Read from
. the wave definition by #R$D0F0.
B $C423,$01

g $C424 Wave Enemy Type
@ $C424 label=Wave_Enemy_Type
D $C424 Enemy type parameter for the current wave, read from the wave definition
. by #R$D0F0 and copied into each spawned entity record.
B $C424,$01

g $C427 Table: Slot Count
@ $C427 label=Table_SlotCount
B $C427,$07

g $C42E Border Colour
@ $C42E label=Border_Colour
B $C42E,$01

g $C42F Bouncing Enemy Count
@ $C42F label=Bouncing_Enemy_Count
B $C42F,$01

g $C447 Player 2 State
@ $C447 label=Player_2_State

g $C46E

g $C48B Player State Swap Buffer
@ $C48B label=Player_State_Swap_Buffer
D $C48B Scratch buffer used by #R$D08B to hold the active player's #N$44-byte
. state block while the inactive player's state is copied over it.
B $C48B,$44

g $C4D1 Playfield Entity List Pointer
@ $C4D1 label=Playfield_Entity_List_Pointer
D $C4D1 Pointer to the current write position in the playfield entity list.
. Set to #R$6000 by #R$D24C before the main game loop is entered.
W $C4D1,$02

g $C4CF Entity Spawn Timer
@ $C4CF label=Entity_Spawn_Timer
D $C4CF Decremented once per frame by the main game loop at #R$CB4F. When it
. reaches zero it is reset to #N$03 and one new entity is spawned adjacent
. to the player's current position.
B $C4CF,$01

g $C4D3 Intro Closing Sprite
@ $C4D3 label=Intro_Closing_Sprite

g $C4D4 Player Y Position
@ $C4D4 label=Player_Y_Position
D $C4D4 Player's current Y pixel position on the playfield. Updated each frame
. by the movement handler in #R$CB4F when the player moves vertically.
B $C4D4,$01

g $C4D5 Player X Position
@ $C4D5 label=Player_X_Position
D $C4D5 Player's current X pixel position on the playfield. Updated each frame
. by the movement handler in #R$CB4F when the player moves horizontally.
B $C4D5,$01

g $C4DA Entity Record Pointer
@ $C4DA label=Entity_Record_Pointer
D $C4DA Pointer to the entity record currently being processed. Set before
. calling #R$D5B1 to identify which entity to remove, and saved on entry to
. the movement handler at #R$D5DD so that the entity can be located after
. sprite-draw calls that may disturb #REGhl.
W $C4DA,$02

g $C4DC RNG Seed
@ $C4DC label=RNG_Seed
D $C4DC Two-byte seed for the linear congruential random number generator. Updated
. each call to #R$D1A8 using the recurrence: seed = seed × #N$21 + #N$29.
W $C4DC,$02

g $C4DE Wave Active Flag
@ $C4DE label=Wave_Active_Flag
D $C4DE Set to #N$01 by #R$D24C once the entity list and playfield are initialised,
. signalling the main game loop at #R$CB4F that the wave is live.
B $C4DE,$01

g $C4E5 Colour Cycle Table Pointer
@ $C4E5 label=Colour_Cycle_Table_Pointer
W $C4E5,$02

g $C4F3 Cached Spawn Pixels
@ $C4F3 label=Cached_Spawn_Pixels
D $C4F3 Y pixel then X pixel for the enemy currently being placed by #R$D0F0,
. written before the screen address build reads them back.
B $C4F3,$02

g $C4F8 Attract Mode Frame Counter
@ $C4F8 label=Attract_Frame_Counter
D $C4F8 Counts down from #N$32 in the attract mode loop at #R$F4EC. Written
. each frame before the per-frame service calls; when it reaches zero,
. control jumps to the high score entry screen at #R$EBC8.
B $C4F8,$01

g $C4F9 Title Strip Blit Parameters
@ $C4F9 label=TitleBlit_Params
D $C4F9 Four bytes read by #R$F606: *#R$C4F9 and *#R$C4FC bound the strip loop,
. *#R$C4FA selects the screen row / band, *#R$C4FB is the run length (LDIR) per
. strip. Filled by #R$F637 before each #R$F606 call.
B $C4F9,$01 Strip loop initial index.
B $C4FA,$01 Row / band parameter for the screen row address lookup table.
B $C4FB,$01 Bytes per strip (LDIR count).
B $C4FC,$01 Strip loop terminal index (stop when #REGb reaches this value).

g $C4FD
g $C4FE
g $C4FF
g $C500
g $C501
g $C502
g $C503

g $C508 Border Colour Step
@ $C508 label=Border_Colour_Step
D $C508 Current step into the border colour cycle (0–7); decremented each
. frame by #R$F0EE and used to index the attribute pair table at #R$F0DE.

g $C509 Entity List Write Pointer
@ $C509 label=Entity_List_Write_Pointer
D $C509 Little-endian pointer into the entity list; loaded at the start of
. #R$E122 and updated with the final write position on exit.
W $C509,$02

g $C50B Entity List Snapshot
@ $C50B label=Entity_List_Snapshot
D $C50B Snapshot of *#R$C509 taken at the start of #R$E122; used alongside
. *#R$C50D to bracket the range of entity records written.
W $C50B,$02

g $C50D Entity List Working Pointer
@ $C50D label=Entity_List_Working_Pointer
D $C50D Working write pointer into the entity list; updated by #R$E149 as each
. record is appended and flushed to *#R$C509 when the build completes.
W $C50D,$02

g $C50F Entity Pointer Stash
@ $C50F label=Entity_Pointer_Stash
D $C50F General-purpose two-byte pointer stash used by several entity routines
. to preserve a working pointer across subroutine calls.
W $C50F,$02

g $C517 Player Y Direction
@ $C517 label=Player_Y_Direction
D $C517 Index of the player's current vertical movement direction. Stored each
. frame by #R$CB4F and used to look up the vertical movement delta and the
. entity type to spawn above or below the player.
B $C517,$01

g $C518 Player X Direction
@ $C518 label=Player_X_Direction
D $C518 Index of the player's current horizontal movement direction. Stored each
. frame by #R$CB4F and used to look up the horizontal movement delta, the
. sprite frame, and the entity type to spawn beside the player.
B $C518,$01

g $C519 Wave Start Pointer
@ $C519 label=WaveStartPointer
D $C519 Little-endian pointer loaded from the word table at #R$D3E4 (indexed from
. #R$D400) when staging a wave after tape load or max-wave reset; copied into
. #R$C409 when clearing player state in #R$D367.
W $C519,$02

g $C51B Animation Frame Pair
@ $C51B label=Animation_Frame_Pair
D $C51B Initial animation frame pair for the current wave. Written as a word by
. #R$D1DD and decremented each frame by #R$CB4F at #R$CC62 until it reaches
. zero.
W $C51B,$02

g $C521 Entity State Pointer
@ $C521 label=Entity_State_Pointer
D $C521 Two-byte pointer written by #R$D9C4 from the entity state table at
. #R$D9EA. Read by #R$D9E0 and executed via JP (HL) to dispatch the current
. entity state handler.
W $C521,$02

g $C52F Entity State Flag
@ $C52F label=Entity_State_Flag
D $C52F Tracks the progress of the active entity state effect. #N$00 = no effect
. running; #N$01 = one step complete; #N$02 = all steps complete. Written by
. #R$D9C4 and polled each frame by #R$D9E0 and #R$DA2A.
B $C52F,$01

g $C532 Death Sequence Mode
@ $C532 label=DeathSequenceMode
D $C532 When #N$01, #R$D367 skips the intro HUD, "PLAYER" messaging and intro delay
. before losing a life, and skips the extra "PLAYER" line in the game-over branch.
. Set from the wave-table path together with the table variant in #REGb.
B $C532,$01

g $C533 Wave Start Delay
@ $C533 label=Wave_Start_Delay
D $C533 Countdown loaded to #N$1A at the start of each wave by #R$CB4F. Checked
. each frame at #R$CB67; while non-zero the frame is skipped and control
. branches to the wave-end handler at #R$CF33.
B $C533,$01

g $C534 Animation Frame Counter One
@ $C534 label=Animation_Frame_Counter_One
D $C534 First per-frame animation counter, initialised to #N$0F at wave start by
. #R$CB4F.
B $C534,$01

g $C536 Animation Frame Counter Two
@ $C536 label=Animation_Frame_Counter_Two
D $C536 Second per-frame animation counter, initialised to #N$0F at wave start by
. #R$CB4F.
B $C536,$01

c $C544 Print Player Score
@ $C544 label=PrintPlayerScore
D $C544 Renders the active player score from packed BCD bytes at #R$C403,
. terminated by #N$FF. Uses #R$8DCC with #N$16 (PRINT AT): row cursor in #REGc
. starts from *#R$C414 and advances by #N$06 per digit row; column is #N$02.
. High and low nibbles may each yield a digit; calls #R$C71F after each
. completed score line. Used from #R$C84F and #R$D317.
@ $C54B label=PrintPlayerScore_NextByte
  $C544,$04 #REGc=*#R$C414 (initial PRINT AT row for this score line).
  $C548,$03 #REGhl=#R$C403 (first BCD byte of the score).
  $C54B,$01 #REGa=*#REGhl (current BCD pair).
  $C54C,$05 Jump to #R$C5A8 if the terminator was read.
  $C551,$02,b$01 Mask the high BCD nibble (AND #N$F0).
  $C553,$03 Jump to #R$C568 if the high nibble is non-zero (print both digits).
  $C556,$04 Add #N$06 to the row cursor (skip an empty high digit row).
  $C55A,$01 #REGa=*#REGhl (reload the BCD pair).
  $C55B,$02,b$01 Mask the low BCD nibble (AND #N$0F).
  $C55D,$03 Jump to #R$C597 if the low nibble is non-zero.
  $C560,$04 Add #N$06 to the row cursor before the next byte.
  $C564,$01 Advance #REGhl to the next BCD byte.
  $C565,$03 Jump back to #R$C54B.
@ $C568 label=PrintPlayerScore_HighNibble
N $C568 High BCD nibble is non-zero; PRINT AT row #REGc, column #N$02, then emit
. the high digit and continue through #R$C584 for the low nibble.
  $C568,$02 #REGa=#N$16 (PRINT AT control code).
  $C56A,$03 Call #R$8DCC.
  $C56D,$01 #REGa=#REGc (PRINT AT row).
  $C56E,$03 Call #R$8DCC.
  $C571,$02 #REGa=#N$02 (PRINT AT column).
  $C573,$03 Call #R$8DCC.
  $C576,$01 #REGa=*#REGhl (BCD pair for digit extraction).
@ $C577 label=PrintPlayerScore_NextDigitHigh
  $C577,$02 Shift #REGa right (SRL).
  $C579,$02 Shift #REGa right (SRL).
  $C57B,$02 Shift #REGa right (SRL).
  $C57D,$02 Shift #REGa right (SRL).
  $C57F,$02,b$01 OR #N$30 to form ASCII (#N$30–#N$39).
  $C581,$03 Call #R$8DCC to print the high digit.
@ $C584 label=PrintPlayerScore_PrintLowNibble
  $C584,$01 #REGa=*#REGhl.
  $C585,$02,b$01 Mask the low nibble (AND #N$0F).
  $C587,$02,b$01 OR #N$30 to form ASCII.
  $C589,$03 Call #R$8DCC to print the low digit.
  $C58C,$01 Advance #REGhl to the next BCD byte.
  $C58D,$01 #REGa=*#REGhl.
  $C58E,$05 Jump to #R$C577 if more BCD bytes follow (high digit path).
  $C593,$03 Call #R$C71F (attribute band refresh for this score line).
  $C596,$01 Return.
@ $C597 label=PrintPlayerScore_LowNibbleOnly
N $C597 High nibble was #N$00 and the low nibble is non-zero; PRINT AT row
. #REGc, column #N$02, then jump to #R$C584 to print the low digit only.
  $C597,$02 #REGa=#N$16 (PRINT AT control code).
  $C599,$03 Call #R$8DCC.
  $C59C,$01 #REGa=#REGc (PRINT AT row).
  $C59D,$03 Call #R$8DCC.
  $C5A0,$02 #REGa=#N$02 (PRINT AT column).
  $C5A2,$03 Call #R$8DCC.
  $C5A5,$03 Jump to #R$C584 (low nibble only).
@ $C5A8 label=PrintPlayerScore_Terminator
N $C5A8 Terminator #N$FF: PRINT AT row #REGc - #N$06, column #N$02, print
. "#CHR$30" (#N$30), then refresh attributes with #R$C71F.
  $C5A8,$02 #REGa=#N$16 (PRINT AT control code).
  $C5AA,$03 Call #R$8DCC.
  $C5AD,$01 #REGa=#REGc.
  $C5AE,$02 Subtract #N$06 from #REGa (row one band higher than #REGc).
  $C5B0,$03 Call #R$8DCC (PRINT AT row).
  $C5B3,$02 #REGa=#N$02 (PRINT AT column).
  $C5B5,$03 Call #R$8DCC.
  $C5B8,$02 #REGa=#N$30 (ASCII zero for the unused high-digit position).
  $C5BA,$03 Call #R$8DCC.
  $C5BD,$03 Call #R$C71F.
  $C5C0,$01 Return.

c $C5C1 Check Score Award Life
@ $C5C1 label=CheckScoreAwardLife
D $C5C1 Compares four bytes at #R$C403 with the template at #R$C418. Returns if
. any player byte is below the matching template byte. Otherwise increments
. *#R$C415, calls #R$C794, adds BCD #N$02 to *#R$C419 with carry into *#R$C415.
. If *#R$C41C is non-zero, tests *#N$FFFF and keyboard port #N$FE, then RST
. #N$08 (error code #N$FF); if *#R$C41C is #N$00, jumps to #R$C605. At #R$C605: pop
. #REGde, #R$F5DA, #R$D24C. Used from #R$C84F.
N $C5C1 Four successive byte compares: #REGde walks #R$C403, #REGhl walks
. #R$C418.
  $C5C1,$03 #REGde=#R$C403 (active player state).
  $C5C4,$03 #REGhl=#R$C418 (four-byte comparison template).
  $C5C7,$01 #REGa=*#REGde.
  $C5C8,$01 Compare with the template byte *#REGhl.
  $C5C9,$01 Return if the player byte is lower (carry set).
  $C5CA,$01 Advance #REGhl.
  $C5CB,$01 Advance #REGde.
  $C5CC,$01 #REGa=*#REGde.
  $C5CD,$01 Compare with *#REGhl.
  $C5CE,$01 Return if the player byte is lower (carry set).
  $C5CF,$01 Advance #REGhl.
  $C5D0,$01 Advance #REGde.
  $C5D1,$01 #REGa=*#REGde.
  $C5D2,$01 Compare with *#REGhl.
  $C5D3,$01 Return if the player byte is lower (carry set).
  $C5D4,$01 Advance #REGhl.
  $C5D5,$01 Advance #REGde.
  $C5D6,$01 #REGa=*#REGde.
  $C5D7,$01 Compare with *#REGhl.
  $C5D8,$01 Return if the player byte is lower (carry set).
  $C5D9,$03 #REGhl=#R$C415 (lives counter).
  $C5DC,$01 Increment *#REGhl (award one life).
  $C5DD,$03 Call #R$C794 (refresh life icons).
  $C5E0,$03 #REGhl=#R$C419 (BCD field adjusted next).
  $C5E3,$02 #REGa=#N$02 (BCD increment).
  $C5E5,$01 Add into the low BCD byte *#REGhl.
  $C5E6,$01 Decimal adjust #REGa (DAA).
  $C5E7,$01 Write the low BCD byte back.
  $C5E8,$01 Return if there was no BCD carry out of *#R$C419.
  $C5E9,$01 Point #REGhl at *#R$C415 again.
  $C5EA,$01 #REGa=*#REGhl.
  $C5EB,$01 Increment the high BCD digit (lives tens).
  $C5EC,$01 Decimal adjust #REGa (DAA).
  $C5ED,$01 Write back *#R$C415.
  $C5EE,$01 Return.
@ $C5EF label=CheckScoreAwardLife_SessionGate
N $C5EF When *#R$C41C is #N$00, skip to #R$C605 (no RAM / keyboard gate).
. Otherwise tests *#N$FFFF and the keyboard before RST #N$08 (error code #N$FF).
  $C5EF,$03 #REGa=*#R$C41C.
  $C5F2,$04 Jump to #R$C605 if the session flag is #N$00.
  $C5F6,$03 #REGa=*#N$FFFF (top of RAM; expected value #N$63 when check runs).
  $C5F9,$03 Return if the value does not match.
  $C5FC,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$7F | SPACE | FULL-STOP | M | N | B }
. TABLE#
  $C600,$01 Rotate #REGa right (test key bit).
  $C601,$01 Return if the expected key is not pressed.
  $C602,$01 Enable interrupts.
  $C603,$01 RST #N$08 (Spectrum firmware / error vector at #N$0008).
B $C604,$01 Error code: #N$FF.
@ $C605 label=CheckScoreAwardLife_Continue
N $C605 Pops one stacked word, then runs the extra-life effect and wave logic.
  $C605,$01 Pop #REGde from the stack (balance the path from #R$C84F).
  $C606,$03 Call #R$F5DA (extra-life sound / setup).
  $C609,$03 Jump to #R$D24C (wave / game-flow handling).

w $C60C Sprite Pixel Data Table
@ $C60C label=Sprite_Pixel_Data_Table
D $C60C Two-byte sprite pixel data addresses indexed by entity type.
. Accessed by doubling the entity type byte and adding to the table
. base. Used by the sprite draw routines to locate the pixel bitmap
. for any given entity.
W $C60C,$A2,$02

b $C6AE Movement Delta Table
@ $C6AE label=Movement_Delta_Table
D $C6AE Sixteen signed Y/X byte-pair movement deltas for player
. direction movement. Each two-byte entry holds a Y delta then an
. X delta. Indexed by direction code and loaded by #R$CB9C to
. compute per-frame player position steps.
B $C6AE,$20,$02

c $C6CE Lookup Vector Table Entry
@ $C6CE label=LookupVectorTableEntry
D $C6CE Returns the word at index #REGa in #R$C60C: #REGhl = #R$C60C + (#REGa *
. #N$02), little-endian word into #REGde. Valid range is #R$C60C through #N$C6CD
. (last word starts at #R$C6CC). No direct CALL to #R$C6CE in this ROM.
  $C6CE,$01 Double #REGa (word stride).
  $C6CF,$03 #REGhl=#R$C60C (table base).
  $C6D2,$02 #REGd=#N$00.
  $C6D4,$01 #REGe=#REGa (word offset in #REGde).
  $C6D5,$01 Add #REGde to #REGhl (pointer to the entry).
  $C6D6,$01 #REGe=*#REGhl (low byte of the word).
  $C6D7,$01 Advance #REGhl.
  $C6D8,$01 #REGd=*#REGhl (high byte of the word).
  $C6D9,$01 Return with the word in #REGde.

c $C6DA Hit Test: 8-Byte Bounds Pair
@ $C6DA label=HitTestBounds8AtHL
D $C6DA Reads four little-endian words at #REGhl (#N$08 bytes). The first two load into
. main #REGbc and #REGde; EXX swaps to the shadow set so the next two words load into
. shadow #REGbc and #REGde while #REGhl walks the same block. After swapping back, four
. ADD/SUB pairs (with further EXX) each end in RET C if the subtraction borrows (no
. hit). If none borrow, falls through to RET with carry clear (hit). #REGhl ends just
. past the eighth byte. Used throughout the gameplay object loop for collisions (among
. others #R$CCDA, #R$CD25, #R$D149, #R$D22D, #R$E03D, #R$EB1C).
N $C6EA Each test adds two bytes from one pair, switches to the shadow pair, subtracts a
. byte from the other rectangle, and RET C on borrow (no overlap on that check).
  $C6DA,$01 #REGb=*#REGhl (first word, low byte).
  $C6DB,$01 Advance #REGhl.
  $C6DC,$01 #REGc=*#REGhl (first word, high byte).
  $C6DD,$01 Advance #REGhl.
  $C6DE,$01 #REGd=*#REGhl (second word, low byte).
  $C6DF,$01 Advance #REGhl.
  $C6E0,$01 #REGe=*#REGhl (second word, high byte).
  $C6E1,$01 EXX (shadow #REGhl continues the load; shadow #REGbc/#REGde hold first pair).
  $C6E2,$01 #REGb=*#REGhl (third word, low byte).
  $C6E3,$01 Advance #REGhl.
  $C6E4,$01 #REGc=*#REGhl (third word, high byte).
  $C6E5,$01 Advance #REGhl.
  $C6E6,$01 #REGd=*#REGhl (fourth word, low byte).
  $C6E7,$01 Advance #REGhl.
  $C6E8,$01 #REGe=*#REGhl (fourth word, high byte).
  $C6E9,$01 EXX (main holds first pair; shadow second pair; #REGhl past all #N$08 bytes).
  $C6EA,$01 #REGa=#REGb.
  $C6EB,$01 #REGa+=#REGd (high bytes from main #REGbc/#REGde).
  $C6EC,$01 EXX.
  $C6ED,$01 Subtract shadow #REGb from #REGa.
  $C6EE,$01 EXX.
  $C6EF,$01 RET C if no hit (carry from SUB).
  $C6F0,$01 EXX.
  $C6F1,$01 #REGa=#REGb.
  $C6F2,$01 #REGa+=#REGd (second high-byte sum).
  $C6F3,$01 EXX.
  $C6F4,$01 Subtract shadow #REGb from #REGa.
  $C6F5,$01 RET C if no hit.
  $C6F6,$01 #REGa=#REGc.
  $C6F7,$01 #REGa+=#REGe (low-byte sum).
  $C6F8,$01 EXX.
  $C6F9,$01 Subtract shadow #REGc from #REGa.
  $C6FA,$01 EXX.
  $C6FB,$01 RET C if no hit.
  $C6FC,$01 EXX.
  $C6FD,$01 #REGa=#REGc.
  $C6FE,$01 #REGa+=#REGe (final low-byte sum).
  $C6FF,$01 EXX.
  $C700,$01 Subtract shadow #REGc from #REGa (last test).
  $C701,$01 RET (carry clear if overlapping).

c $C702 Dispatch Handler Pointer From HL
@ $C702 label=DispatchWordFromHL
D $C702 Chained trampoline: pushes resume address #R$C702, loads a #N$16-bit routine
. pointer from #REGhl, advances #REGhl by #N$02, then jumps to that pointer via the
. stack. When the handler RETs, execution continues at #R$C702 for the next table
. entry, so handlers should leave #REGhl valid for the following word unless the chain
. ends. Used from #R$CC5F, #R$CEBF, #R$CF45, #R$D27C with tables such as #R$6100.
  $C702,$03 #REGde=#R$C702 (resume address after each nested RET).
  $C705,$01 Save the resume address on the stack.
  $C706,$01 #REGe=*#REGhl (handler pointer, low byte).
  $C707,$01 Advance #REGhl.
  $C708,$01 #REGd=*#REGhl (handler pointer, high byte).
  $C709,$01 Advance #REGhl past the pointer.
  $C70A,$01 Stack the handler address.
  $C70B,$01 RET to the handler (next RET pops back to #R$C702).

g $C70C Help Bar Attribute Sequence
@ $C70C label=HelpBarAttributeSequence
D $C70C Seven attribute bytes (#N$41 / #N$42 / #N$44 ink cycling) and a #N$00
. terminator, consumed from #R$C713 when #R$C777 arms #REGhl here after the "H" key
. path through #R$C77D.
B $C70C,$01 #COLOUR(#PEEK(#PC)).
L $C70C,$01,$06
B $C712,$01 Terminator.

c $C713 Update Attribute Bar
@ $C713 label=UpdateAttributeBar
D $C713 Paints the HUD attribute border with *#R$C42E and writes the cycling colour
. from #R$C70C to #N$07 attribute cells at *#R$C420. Checks the H key (help) and
. F key (restart). #R$C71F is also called directly by #R$C5BD.
  $C713,$03 #REGhl=*#R$C4E5 (colour cycle table pointer).
@ $C716 label=UpdateAttributeBar_FetchColour
  $C716,$05 Read the next colour byte; jump to #R$C777 if zero (table end).
  $C71B,$04 Advance the table pointer and save it back to *#R$C4E5.
@ $C71F label=UpdateAttributeBar_FillBorder
N $C71F Fill the attribute area border with *#R$C42E (current border colour).
  $C71F,$03 #REGhl=#N$5800 (attribute area start).
  $C722,$03 #REGa=*#R$C42E (border colour).
  $C725,$02 Top rows loop count #N$40 (#REGb=#N$40).
@ $C727 label=UpdateAttributeBar_TopFillLoop
  $C727,$04 Write the border colour to #N$40 attribute cells (top two rows).
  $C72B,$02 Side-column loop count #N$15 (#REGb=#N$15).
  $C72D,$03 #REGde=#N$001F (stride between left and right edge columns).
@ $C730 label=UpdateAttributeBar_SideFillLoop
  $C730,$06 Write the border colour to the left (col #N$00) and right (col #N$1F)
. edge cells of #N$15 consecutive rows.
  $C736,$02 Bottom row loop count #N$20 (#REGb=#N$20).
@ $C738 label=UpdateAttributeBar_BottomFillLoop
  $C738,$04 Write the border colour to #N$20 attribute cells (bottom row).
N $C73C Load the current colour byte from the table into #REGc.
  $C73C,$05 Back up one step in the table and load the colour byte into #REGc.
  $C741,$02 #REGh=#N$58 (high byte of the colour bar attribute row pointer).
  $C743,$04 #REGl=*#R$C420 (colour bar column offset).
  $C747,$02 Colour bar loop count #N$07 (#REGb=#N$07).
@ $C749 label=UpdateAttributeBar_ColourBarLoop
  $C749,$04 Write the cycling colour (#REGc) to #N$07 consecutive attribute cells.
N $C74D Check H (help) and F (restart) keys.
  $C74D,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
  $C751,$02,b$01 Test the H key (bit 4).
  $C753,$03 Jump to #R$C760 if H is pressed.
  $C756,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
  $C75A,$02,b$01 Test the F key (bit 3).
  $C75C,$03 Jump to #R$EBBC if F is pressed (restart the game).
  $C75F,$01 Return.
@ $C760 label=UpdateAttributeBar_HKeyWait_D
N $C760 H key pressed: poll via #R$C77D, counting down #REGd then #REGe then
. #REGd again.
  $C760,$03 Call #R$C77D.
  $C763,$04 Decrease #REGd and loop back to #R$C760 while non-zero.
@ $C767 label=UpdateAttributeBar_HKeyWait_E
  $C767,$03 Call #R$C77D.
  $C76A,$04 Decrease #REGe and loop back to #R$C767 while non-zero.
@ $C76E label=UpdateAttributeBar_HKeyWait_D2
  $C76E,$03 Call #R$C77D.
  $C771,$04 Decrease #REGd and loop back to #R$C76E while non-zero.
  $C775,$01 Return.
  $C776,$01 Return.
@ $C777 label=UpdateAttributeBar_ResetTable
N $C777 Table exhausted: reset the pointer to the start of #R$C70C and continue.
  $C777,$03 #REGhl=#R$C70C (start of the colour cycle table).
  $C77A,$03 Jump to #R$C716 (fetch the first colour byte).

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

c $C794 Draw Lives Display
@ $C794 label=DrawLivesDisplay
D $C794 Refreshes the on-screen life icons. Runs #N$07 passes of #R$D4BB (masked
. clear) with glyph code #N$1B, vertical seed *#R$C416 and step *#R$C417. If
. *#R$C415 is zero, returns; else #REGd is the lives count capped at #N$07, the
. vertical seed is reloaded from *#R$C416, and that many OR-blits run via
. #R$D486 with the same glyph and stride. Called from #R$D317 and #R$C5C1.
  $C794,$02 #REGd=#N$07 (fixed passes for the clear / background phase).
  $C796,$04 #REGe=*#R$C416 (initial vertical parameter for the first phase).
@ $C79A label=DrawLivesDisplay_ClearLoop
N $C79A Seven stacked clears using #R$D4BB (CPL and AND into the display file).
  $C79A,$01 Stash #REGde on the stack.
  $C79B,$02 #REGa=#N$1B (life-icon character / glyph selector).
  $C79D,$01 #REGb=#REGe (vertical argument for the blit helper).
  $C79E,$02 #REGc=#N$00.
  $C7A0,$03 Call #R$D4BB (masked clear at this cell).
  $C7A3,$01 Restore #REGde from the stack.
  $C7A4,$03 #REGa=*#R$C417 (vertical spacing between stacked slots).
  $C7A7,$01 Add #REGe to #REGa.
  $C7A8,$01 #REGe=#REGa (advance the vertical parameter).
  $C7A9,$01 Decrement #REGd.
  $C7AA,$03 Loop back to #R$C79A until all #N$07 clear passes finish.
  $C7AD,$03 #REGhl=#R$C415 (lives counter).
  $C7B0,$01 #REGa=*#REGhl.
  $C7B1,$02 Return if there are no lives to draw.
  $C7B3,$02 Compare with #N$08.
  $C7B5,$02 Jump to #R$C7B9 if the count is below #N$08 (use it as-is).
  $C7B7,$02 #REGa=#N$07 (cap at seven visible life icons).
@ $C7B9 label=DrawLivesDisplay_CountReady
  $C7B9,$01 #REGd=#REGa (number of OR-blits to perform).
  $C7BA,$01 Advance #REGhl to #R$C416 (vertical seed for the draw phase).
  $C7BB,$01 #REGe=*#REGhl.
@ $C7BC label=DrawLivesDisplay_DrawLoop
N $C7BC Each iteration OR-merges a life glyph via #R$D486 (see #R$D486).
  $C7BC,$01 Stash #REGde on the stack.
  $C7BD,$02 #REGa=#N$1B.
  $C7BF,$01 #REGb=#REGe.
  $C7C0,$02 #REGc=#N$00.
  $C7C2,$03 Call #R$D486 (OR-blit at this cell).
  $C7C5,$01 Restore #REGde from the stack.
  $C7C6,$03 #REGa=*#R$C417.
  $C7C9,$01 Add #REGe to #REGa.
  $C7CA,$01 #REGe=#REGa (advance the vertical parameter).
  $C7CB,$01 Decrement #REGd.
  $C7CC,$02 Loop back to #R$C7BC while more icons remain.
  $C7CE,$01 Return.

w $C7CF Narrow Entity Sprite Data
@ $C7CF label=Narrow_Entity_Sprite_Data
D $C7CF Pixel data for narrow entity sprites (#N$10 bytes per entry),
. addressed via the lookup table at #R$C60C and rendered by #R$C84F.
. Each entry provides 8 rows of 2 pixel bytes each.

c $C84F Erase Narrow Entity Sprite
@ $C84F label=Erase_Narrow_Entity_Sprite
D $C84F Entry point for erasing a narrow entity sprite. Sets erase mode
. (attribute writes disabled) and jumps to #R$C85A.
R $C84F HL Entity record pointer
  $C84F,$07 Set erase mode: clear the attribute-write flag in #REGd' and
. jump to #R$C85A.

c $C856 Draw Narrow Entity Sprite
@ $C856 label=Draw_Narrow_Entity_Sprite
D $C856 Entry point for drawing a narrow entity sprite. Sets draw mode
. (attribute writes enabled) and falls through to #R$C85A. XOR-renders
. 8 rows of 2 bytes each; the sprite type is looked up in #R$C60C for
. the pixel data address, and the entity colour is written to the 2
. attribute cells flanking each pixel row.
R $C856 HL Entity record pointer
  $C856,$04 Set draw mode: set the attribute-write flag in #REGd'.
@ $C85A label=Render_Narrow_Entity_Sprite
N $C85A Compute the sprite pixel data pointer and screen coordinate.
  $C85A,$02 Copy the entity record pointer to #REGbc.
  $C85C,$05 Read the sprite type byte and form a word offset in #REGde.
  $C861,$07 Look up the sprite pixel data address in the table at #R$C60C.
  $C868,$02 Restore the entity record pointer to #REGhl.
  $C86A,$05 Advance past the sprite type byte and load the screen row
. address high byte from the entity record.
  $C86F,$04 Shift the coordinate into #REGb to build the screen address
. high byte.
  $C873,$01 Stash the screen coordinate on the stack.
  $C874,$10 Load the column byte, clear #REGhl, and distribute its bits
. into #REGl via successive right-rotations to form the pixel offset.
  $C884,$05 Add the sprite data base to the offset, set #REGbc as the
. sprite pixel data pointer, and restore the screen coordinate.
  $C889,$02 Stash the column offset in alternate #REGc and return to the
. main register set.
N $C88B Row 1: XOR-render the first sprite row and optionally write the
. entity colour to the flanking attribute cells.
  $C88B,$05 Compute the first screen row address from the entity record
. into #REGde.
  $C890,$0A XOR-render 2 sprite pixel bytes at the first screen row.
  $C89A,$06 Check whether attribute writes are enabled; jump to #R$C8AF
. to skip the colour write in erase mode.
  $C8A0,$04 Convert the screen address high byte to an attribute address.
  $C8A4,$02,b$01 Mask to the attribute page bits.
  $C8A6,$02,b$01 Set the attribute area high byte.
  $C8A8,$01 Update #REGh to point into attribute RAM.
  $C8A9,$05 Fetch the entity colour via #REGb' and write it to
. the first attribute cell.
  $C8AE,$01 Write the entity colour to the second attribute cell.
@ $C8AF label=Render_Narrow_Entity_Sprite_Row2
N $C8AF Rows 2–7: XOR-render the remaining sprite rows without attribute
. writes (attribute colour was set once on row 1).
  $C8AF,$04 Restore the entity record pointer and fetch the column offset
. from alternate #REGc.
  $C8B3,$05 Compute the second screen row address from the entity record.
  $C8B8,$0B XOR-render 2 sprite bytes at the second screen row and
. restore the entity record pointer.
  $C8C3,$03 Fetch the column offset from alternate #REGc.
  $C8C6,$05 Compute the third screen row address from the entity record.
  $C8CB,$0B XOR-render 2 sprite bytes at the third screen row and restore.
  $C8D6,$03 Fetch the column offset from alternate #REGc.
  $C8D9,$05 Compute the fourth screen row address from the entity record.
  $C8DE,$0B XOR-render 2 sprite bytes at the fourth screen row and restore.
  $C8E9,$03 Fetch the column offset from alternate #REGc.
  $C8EC,$05 Compute the fifth screen row address from the entity record.
  $C8F1,$0B XOR-render 2 sprite bytes at the fifth screen row and restore.
  $C8FC,$03 Fetch the column offset from alternate #REGc.
  $C8FF,$05 Compute the sixth screen row address from the entity record.
  $C904,$0B XOR-render 2 sprite bytes at the sixth screen row and restore.
  $C90F,$03 Fetch the column offset from alternate #REGc.
  $C912,$05 Compute the seventh screen row address from the entity record.
  $C917,$0B XOR-render 2 sprite bytes at the seventh screen row and
. restore the entity record pointer.
N $C922 Row 8: XOR-render the final sprite row and write the entity colour
. to the flanking attribute cells if in draw mode.
  $C922,$03 Fetch the column offset from alternate #REGc.
  $C925,$05 Compute the eighth screen row address from the entity record.
  $C92A,$0A XOR-render 2 sprite bytes at the eighth screen row.
  $C934,$05 Return without writing attributes if in erase mode.
  $C939,$04 Convert the screen address high byte to an attribute address.
  $C93D,$02,b$01 Mask to the attribute page bits.
  $C93F,$02,b$01 Set the attribute area high byte.
  $C941,$01 Update #REGh to point into attribute RAM.
  $C942,$04 Fetch the entity colour via #REGb' and write it to
. the first attribute cell.
  $C946,$02 Write the entity colour to the second attribute cell.
  $C948,$01 Return.

c $C949 Erase Wide Entity Sprite
@ $C949 label=Erase_Wide_Entity_Sprite
D $C949 Entry point for erasing a wide entity sprite. Sets erase mode then
. falls through to #R$C954. In erase mode the attribute write is skipped.
  $C949,$04 Set erase mode (attribute write disabled).
  $C94D,$03 Jump to #R$C954.

c $C950 Draw Wide Entity Sprite
@ $C950 label=Draw_Wide_Entity_Sprite
D $C950 Draws or erases a wide entity's sprite on the display. #R$C950 sets
. draw mode so the entity colour is written to the attribute area. #R$C949
. sets erase mode and skips the attribute write. Both paths enter #R$C954,
. which reads the entity type to look up sprite data from #R$C60C, computes
. the screen position from the Y and X bytes, then XOR-blends sixteen pixel
. rows of sprite data onto the display across three bytes (24 pixels) wide.
R $C950 HL Entity record pointer
  $C950,$04 Set draw mode (attribute write enabled).
@ $C954 label=Draw_Wide_Entity_Sprite_Render
  $C954,$02 Copy the entity record pointer to #REGbc.
  $C956,$0C Look up the sprite data address for this entity type.
  $C962,$02 Copy the entity record pointer from #REGbc.
  $C964,$09 Read the entity's Y position and form the pixel row address.
  $C96D,$0F Read the X position and extract the byte column and bit offset.
  $C97C,$03 Save the pixel bit offset in the shadow register.
  $C97F,$09 Compute the sprite pixel data address and add the column offset.
  $C988,$02 Copy the sprite data pointer to #REGbc.
  $C98A,$01 Restore the pixel row address from the stack.
  $C98B,$03 Read the pixel bit offset from the shadow register.
@ $C98E label=Draw_Wide_Entity_Sprite_Row1
N $C98E Render the sprite row by row. Each row XOR-blends three bytes of
. pixel data onto the display. After every ninth row the entity's colour
. is written to three screen attribute cells.
  $C98E,$14 Blit the first sprite row onto the display.
  $C9A2,$06 Jump to #R$C9B9 if in erase mode (skip the attribute write).
  $C9A8,$04 Compute the attribute area address from the current screen row.
  $C9AC,$02,b$01 Keep only the row address bits.
  $C9AE,$02,b$01 Set the attribute memory flag.
  $C9B0,$09 Write the entity's colour to three attribute cells.
@ $C9B9 label=Draw_Wide_Entity_Sprite_Row2
  $C9B9,$18 Blit row two.
  $C9D1,$18 Blit row three.
  $C9E9,$18 Blit row four.
  $CA01,$18 Blit row five.
  $CA19,$18 Blit row six.
  $CA31,$18 Blit row seven.
  $CA49,$18 Blit row eight.
  $CA61,$18 Blit row nine.
  $CA79,$06 Jump to #R$CA90 if in erase mode (skip the attribute write).
  $CA7F,$04 Compute the attribute area address from the current screen row.
  $CA83,$02,b$01 Keep only the row address bits.
  $CA85,$02,b$01 Set the attribute memory flag.
  $CA87,$09 Write the entity's colour to three attribute cells.
@ $CA90 label=Draw_Wide_Entity_Sprite_Row10
  $CA90,$18 Blit row ten.
  $CAA8,$18 Blit row eleven.
  $CAC0,$18 Blit row twelve.
  $CAD8,$18 Blit row thirteen.
  $CAF0,$18 Blit row fourteen.
  $CB08,$18 Blit row fifteen.
  $CB20,$18 Blit row sixteen.
  $CB38,$05 Return if in erase mode (skip the final attribute write).
  $CB3D,$04 Compute the attribute area address from the current screen row.
  $CB41,$02,b$01 Keep only the row address bits.
  $CB43,$02,b$01 Set the attribute memory flag.
  $CB45,$0A Write the entity's colour to three attribute cells and return.

c $CB4F Main Game Loop
@ $CB4F label=Main_Game_Loop
D $CB4F Wave-active game loop entry, called from #R$D24C once the entity list
. and playfield are ready. Initialises the player's starting screen position
. and frame counters, copies the sprite template via #R$D519, then falls
. into the per-frame control poll at #R$CB67. Each frame: reads
. the controller via #R$F6C3, moves and redraws the player sprite, spawns
. one new entity every three frames adjacent to the player, dispatches all
. active entity handlers via #R$C702, updates the colour bar and protection
. checks, then loops back to #R$CB67.
N $CB4F Initialise the player's screen position and frame counters for the
. start of the wave.
  $CB4F,$06 Point #REGhl at #R$C4D4 and set the starting screen
. row to #N$5C.
  $CB55,$07 Set the starting screen column to #N$7D and reset the wave-start
. delay counter at #R$C533 to #N$1A.
  $CB5C,$0B Set the animation frame counters at #R$C534 and #R$C536 to #N$0F
. and copy the sprite template via #R$D519.
N $CB67 Per-frame start: check whether the wave is still active before
. processing input.
@ $CB67 label=Main_Loop_Poll
  $CB67,$07 If the wave-start delay counter at #R$C533 is non-zero, jump to
. #R$CF33 (wave-end / game-over handling).
N $CB6E Read the controller and map the input to player movement directions.
@ $CB6E label=Main_Loop_Frame
  $CB6E,$03 Read the controller state via #R$F6C3.
  $CB71,$05 Apply vertical input processing via #R$CE9D and store the result
. in #REGc.
  $CB76,$05 Apply horizontal input processing via #R$CE72 and store the result
. in #REGb.
  $CB7B,$04 If the direction is neutral (#N$0F), skip to #R$CB82.
  $CB7F,$03 Store the updated X direction at #R$C518.
@ $CB82 label=Main_Loop_Update_Y
  $CB82,$08 If the vertical direction changed, store it at #R$C517.
@ $CB8A label=Main_Loop_Move_Player
N $CB8A Move the player sprite if a direction was input. Neutral direction
. (#N$0F) means no movement — skip directly to entity spawning.
  $CB8A,$05 If no horizontal direction, skip to #R$CBD3.
  $CB8F,$09 Build the sprite frame word offset from the X direction and stash
. it; point #REGhl at #R$C4D3 and erase the current player
. sprite via #R$D630.
  $CB98,$03 Erase the current player sprite via #R$D630.
  $CB9B,$0F Look up the movement delta for the current direction in the table
. at #R$C6AE; add the Y delta to #R$C4D4.
  $CBAA,$04 Reject the Y move if the new position is above the playfield top
. or below the bottom edge.
  $CBAE,$01 Write the updated Y position.
@ $CBAF label=Main_Loop_Clamp_X
  $CBAF,$06 Add the X delta to #R$C4D5.
  $CBB5,$04 Reject the X move if the new position is past the left edge.
  $CBB9,$02 Reject the X move if past the right edge.
  $CBBB,$01 Write the updated X position.
@ $CBBC label=Main_Loop_Update_Sprite
N $CBBC Select the sprite frame for the new direction and redraw the player.
  $CBBC,$10 Look up the sprite frame index for the current X direction in
. #R$D620; write it to #R$C4D3.
  $CBCC,$07 Set the player colour to #COLOUR$47 in #REGb' and redraw the
. player sprite via #R$D637.
N $CBD3 Every three frames spawn one new entity adjacent to the player.
@ $CBD3 label=Main_Loop_Entity_Spawn
  $CBD3,$04 Decrement the entity spawn timer at #R$C4CF.
  $CBD7,$03 If the timer has not reached zero, skip to #R$CC5C.
  $CBDA,$02 Reset the spawn timer to #N$03.
  $CBDC,$06 Load the entity list end pointer from #R$C4D1 and write the
. movement handler address #R$D5DD to the entity list.
  $CBE2,$04 Advance past the handler address word in the entity list.
  $CBE6,$03 Save the entity record write pointer to #R$C4DA.
  $CBE9,$03 Load the Y direction index from #R$C517.
  $CBEC,$0B Index the entity type table at #R$D4F1 by Y direction and write
. the entity type to the entity record.
  $CBF7,$01 Advance to the next entity record field.
  $CBF8,$0A Load the Y direction again, scale it to a byte offset (×8), and
. look up the sprite pixel offsets in #R$C7CF.
  $CC02,$06 Clear the high byte of the offset and index into
. #R$C7CF.
  $CC08,$01 Add the direction offset to the sprite data base address.
  $CC09,$0A Compute the entity's initial Y position from #R$C4D4
. plus the sprite Y offset; write both bytes to the entity record.
  $CC13,$04 Write the X position bytes derived from #R$C4D5.
  $CC17,$06 Add the sprite Y check offset to the player Y position and reject
. the spawn if the result is above the playfield top edge.
  $CC1D,$04 Reject the spawn if the Y position is below the playfield bottom
. edge (#N$B8).
  $CC21,$02 Reject if below the bottom edge.
  $CC23,$03 Write the validated Y position field to the entity record.
  $CC26,$06 Check the X position is within the playfield horizontal bounds
. (#N$08–#N$F7).
  $CC2C,$04 Reject the spawn if the X position is past the left edge.
  $CC30,$02 Reject if past the right edge.
  $CC32,$03 Write the validated X position field to the entity record.
  $CC35,$05 Copy the remaining four entity record bytes via LDIR.
  $CC3A,$07 Mark the end of the entity record and update the entity list end
. pointer at #R$C4D1.
  $CC41,$05 Initialise the entity via #R$D9C4.
  $CC46,$07 Reload the entity record pointer from #R$C4DA
. and set the entity colour to #COLOUR$47 in #REGb'.
  $CC4D,$03 Draw the spawned entity sprite via #R$C856.
  $CC50,$03 Reload the entity list end pointer from #R$C4D1.
@ $CC53 label=Main_Loop_Write_Terminator
  $CC53,$09 Write the playfield entity handler #N$CE62 and the #N$FF sentinel
. as the entity list terminator.
N $CC5C Dispatch all active entity handlers, update animation and colour bar.
@ $CC5C label=Main_Loop_Entity_Update
  $CC5C,$03 Set #REGhl to the start of the entity list at #R$6100.
  $CC5F,$03 Dispatch all entity handlers in the list via #R$C702.
  $CC62,$0B Decrement the animation counter at #R$C51B if it is non-zero.
@ $CC6D label=Main_Loop_Colour_Bar_Update
  $CC6D,$09 Update the colour bar via #R$C713, run the protection check via
. #R$C5C1, and call the game state update via #R$D9E0.
  $CC76,$06 Run the copy protection gate via #R$C5EF and loop back to
. #R$CB67.
N $CC7C Out-of-bounds abort: the new entity would fall outside the playfield.
. Skip the spawn but still write the entity list terminator.
@ $CC7C label=Main_Loop_Abort_Spawn
  $CC7C,$05 Reload the entity list end pointer from #R$C4D1 and jump to
. #R$CC53.

c $CC81 Draw Spawned Entity
@ $CC81 label=Draw_Spawned_Entity
D $CC81 Reads the sprite type and screen address from the entity record at
. #REGhl, looks up the sprite pixel data in #R$C60C, then XOR-blits eight
. pixel rows onto the screen. Falls through to #R$CCBD
. to write the entity's attribute colour from the colour cycle table.
. Called immediately after a new entity is written to the entity list.
  $CC81,$06 Read the entity sprite type into #REGa and the screen address
. into #REGde.
  $CC87,$05 Stash the entity record pointer in #REGbc and double the sprite
. type to form the lookup word offset.
  $CC8C,$07 Index the sprite data table at #R$C60C and restore the entity
. record pointer from the stack.
  $CC93,$04 Load the sprite pixel data address into #REGhl.
  $CC97,$26 XOR-blit eight pixel rows of sprite data onto the screen.
@ $CCBD label=Draw_Spawned_Entity_Attribute
N $CCBD Write the entity's current colour from the colour cycle table to the
. attribute cell at the entity's screen position.
  $CCBD,$04 Read the low byte of the attribute cell address from the entity
. record into #REGl.
  $CCC1,$01 Form the attribute cell address high byte in #REGh.
  $CCC2,$07 Load the current colour byte from the colour cycle table at #R$C4E5
. and write it to the attribute cell.
  $CCC9,$04 Write the colour, restore the entity record pointer, advance past
. two fields, and return.
  $CCCD,$01 Return.

c $CCCE Primary Enemy Entity Handler
@ $CCCE label=Primary_Enemy_Entity_Handler
D $CCCE Entity handler stored in primary wave enemy records. Called once per
. frame by the entity dispatcher in #R$C702. Searches the entity list for a
. collision-free position via #R$CD18. If a free position exists, hands off
. to #R$CCE9 to draw the entity and detect contact with other
. enemies. Otherwise checks whether the enemy touches the player via #R$C6DA;
. if the player is hit, the death transition fires via #R$D2BC.
  $CCCE,$05 Switch to alternate registers and search the entity list for a
. free slot via #R$CD18; restore main registers.
  $CCD3,$02 If a free slot was found, hand off to #R$CCE9.
  $CCD5,$05 Load the player's screen position into alternate #REGhl.
  $CCDA,$03 Test whether the enemy's bounds overlap the player via #R$C6DA.
  $CCDD,$03 If the player is hit, trigger the death transition via #R$D2BC.
  $CCE0,$06 Advance the entity list pointer four bytes and save it in #REGbc.
  $CCE6,$03 Write the entity's attribute colour via #R$CCBD.

c $CCE9 Process Enemy Entity
@ $CCE9 label=Process_Enemy_Entity
D $CCE9 Draws a wave enemy entity's sprite, updates its handler to the entity
. update completion routine, then checks for contact with the player. If the
. enemy touches the player, the entity is erased, removed from the list, the
. wave enemy count is decremented, and execution returns to the dispatcher.
  $CCE9,$08 Stash the entity record pointer, advance four bytes to the screen
. address field, and draw the entity sprite via #R$CC81.
  $CCF1,$0A Restore the entity record pointer, step back to the handler field,
. and write the entity update completion address #R$CD13.
  $CCFB,$06 Switch to alternate registers, subtract 6 from the entity list
. position to locate the record within the list.
  $CD01,$05 Stash the record position, erase the entity sprite via #R$C84F,
. and restore the position.
  $CD06,$06 Save the record pointer to #R$C4DA and remove
. the entity from the list via #R$D5B1.
  $CD0C,$06 Decrement the wave enemy count at #R$C423 and set
. the entity colour to #COLOUR$47 in #REGb'.
  $CD12,$01 Return to the main register set.

c $CD13 Advance Entity Pointer
@ $CD13 label=Advance_Entity_Pointer
D $CD13 Written into entity records as the per-frame handler once an entity
. has been processed. Advances #REGhl by #N$0A bytes to step past the
. current record and returns to the entity dispatcher.
  $CD13,$04 Add #N$0A to #REGhl to step past the current entity record.
  $CD17,$01 Return to the entity dispatcher.

c $CD18 Find Colliding Entity
@ $CD18 label=Find_Colliding_Entity
D $CD18 Walks the entity list from #R$6000, testing each record's bounds
. against the current entity via #R$C6DA. Returns without carry if no
. collision is found (list exhausted). Returns with carry set if the current
. entity's position overlaps another entity's bounds.
  $CD18,$03 Point #REGhl to the start of the entity list at #R$6000.
@ $CD1B label=Find_Colliding_Entity_Check
  $CD1B,$07 Skip the handler address and read the state byte. If it is the
. #N$FF sentinel, set carry and return (end of list reached).
  $CD22,$06 Advance past three more bytes and test this entity's bounds
. against the current position via #R$C6DA.
  $CD28,$05 Adjust alternate #REGhl back by three and return without carry
. if the bounds do not overlap.
  $CD2D,$05 Advance four bytes to the next entity record.
  $CD32,$02 Check the next entity.

c $CD34 Clear Colour Bar Column
@ $CD34 label=Clear_Colour_Bar_Column
D $CD34 Clears a seven-column, six-pixel-row strip from the screen pixel
. area at the column position held in #R$C420, then jumps to #R$C544
. to redraw the column.
  $CD34,$04 Prepare to clear six pixel rows of the colour bar column.
@ $CD38 label=Clear_Colour_Bar_Column_Row
N $CD38 For each row, point to the target column and zero seven pixel cells.
  $CD38,$04 Point to the colour bar column in the current pixel row.
  $CD3C,$0E Zero seven pixel cells at the column position.
  $CD4A,$03 Advance to the next pixel row and repeat until all six are cleared.
  $CD4D,$03 Jump to #R$C544 to redraw the display column.

c $D070 Clear Screen Buffer
@ $D070 label=ClearScreenBuffer
  $D070,$0D Clear #N$1800 bytes of data from #N$4000 to #N$5B00.
  $D07D,$01 Return.

c $D07E Set Background Colour
@ $D07E label=SetBackgroundColour
R $D07E A Attribute byte to fill the entire attribute area with
  $D07E,$0C Write #REGa to #N$02FF bytes of data from #N$5800 to #N$5AFF.
  $D08A,$01 Return.

c $D08B Swap Player State
@ $D08B label=Swap_Player_State
D $D08B Swaps the active and inactive player's #N$44-byte state blocks between
. the player 1 slot at #R$C403 and the player 2 slot at #R$C447, using
. #R$C48B as a scratch buffer. Called each time the game switches between
. the two players. The swap is a three-step rotate through the scratch
. buffer: save active, overwrite active with inactive, restore saved.
  $D08B,$0B Save the active player's #N$44-byte state block to the scratch buffer
. at #R$C48B.
  $D096,$08 Copy the other player's state block from #R$C447 into the active
. player's slot at #R$C403.
  $D09E,$08 Copy the saved state block from #R$C48B into the other player's slot
. at #R$C447.
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
  $D0C4,$08 Shift #REGa right four positions to isolate the tens digit
. (high nibble, #N$00–#N$09).
  $D0CC,$02,b$01 Convert the tens digit to its ASCII character ("#CHR$30"–"#CHR$39").
  $D0CE,$03 Call #R$8DCC to print the tens digit.
  $D0D1,$03 #REGa=*#R$C408 (BCD wave number again).
  $D0D4,$02,b$01 Isolate the units digit (low nibble, #N$00–#N$09).
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

c $D0F0 Spawn Primary Wave Enemies
@ $D0F0 label=Spawn_Primary_Wave_Enemies
D $D0F0 Reads the enemy count and type for the current wave from the definition
. pointed to by #REGhl, then spawns that many primary wave entities at random
. valid screen positions by writing records into the entity list at #R$C509.
. Each entity is placed at a random column (1–30) and row (2–22), scaled to
. pixel coordinates, and drawn to the screen via #N$CC81. If the count is zero
. the entity list is left empty and the routine returns immediately.
R $D0F0 HL Pointer to the wave enemy definition (count byte followed by type byte)
  $D0F0,$05 Read the enemy count from the wave definition and store at #R$C423.
  $D0F5,$01 Advance #REGhl to the enemy type byte.
  $D0F6,$01 Read the enemy type parameter from the wave definition.
  $D0F7,$03 Store the enemy type parameter at #R$C424.
  $D0FA,$01 Advance the wave definition pointer.
  $D0FB,$01 Stash the wave definition pointer on the stack.
  $D0FC,$03 Load the entity list write pointer from *#R$C509.
  $D0FF,$05 Skip spawning if the wave has no enemies.
N $D104 For each enemy: write the entity handler, pick a random valid screen
. position, build the entity record, and draw the sprite.
@ $D104 label=Spawn_Primary_Wave_Enemies_Loop
  $D104,$01 Stash the enemy count on the stack.
  $D105,$03 Load the primary entity handler address #R$CCCE into #REGde.
  $D108,$03 Write the primary entity handler address into the entity list.
  $D10B,$01 Advance #REGhl past the handler bytes.
@ $D10C label=Spawn_Primary_Wave_Enemies_Get_X
  $D10C,$03 Generate a random column via #R$D1BF.
  $D10F,$02,b$01 Mask to columns 0–31.
  $D111,$06 Retry if the column is at the left or right wall.
  $D117,$01 Copy the valid column to #REGb.
@ $D118 label=Spawn_Primary_Wave_Enemies_Get_Y
  $D118,$03 Generate a random row via #R$D1BF.
  $D11B,$02,b$01 Mask to rows 0–31.
  $D11D,$08 Retry if the row is too close to the top or bottom edge.
  $D125,$0C Scale the row and column to pixel coordinates (multiply by 8).
  $D131,$01 Write the Y pixel to the entity record.
  $D132,$03 Cache the Y pixel at #R$C4F3.
  $D135,$01 Advance #REGhl to the X slot in the entity record.
  $D136,$01 Write the X pixel to the entity record.
  $D137,$04 Copy the X pixel from #REGb into #REGa and cache it at
. #R$C4F3(#N$C4F4).
  $D13B,$01 Advance #REGhl to the colour slot.
  $D13C,$05 Write #INK$07 to the colour and type bytes.
  $D141,$03 Step back three bytes to point at the start of the entity record.
  $D144,$05 Load the entity spawn handler address #R$D1C7 into alternate #REGhl.
  $D149,$03 Test whether this position overlaps an existing entity via #R$C6DA.
  $D14C,$05 Retry with new coordinates if the position is occupied.
  $D151,$04 Advance past the entity record header fields.
  $D155,$05 Copy the wave enemy type from #R$C424 into the entity record.
N $D15A Build the on-screen pixel address and attribute address from the cached
. pixel coordinates at #R$C4F3.
  $D15A,$01 Copy #REGhl to #REGde (entity record pointer now in #REGde).
  $D15B,$03 Point #REGhl at the cached pixel coordinates at #R$C4F3.
  $D15E,$01 Read the Y pixel (row) from the cache.
  $D15F,$01 Advance #REGhl to the X pixel byte.
  $D160,$01 Read the X pixel (column) from the cache.
  $D161,$01 Move the Y pixel into #REGl for the row term.
  $D162,$02 Load the screen address high-byte base #N$45 into #REGb.
  $D164,$02 Shift the X pixel left in #REGc.
  $D166,$02 Roll the carry into the screen high byte in #REGb.
  $D168,$02 Load the second high-byte term #N$46 into #REGh.
  $D16A,$02 Shift the Y pixel left in #REGl.
  $D16C,$02 Finish forming the screen address high byte in #REGh.
  $D16E,$01 Read the low byte of the pixel data pointer from the table.
  $D16F,$01 Advance #REGhl to the high byte.
  $D170,$01 Read the high byte of the pixel data pointer.
  $D171,$01 Form the full pixel data pointer in #REGhl (low in #REGl).
  $D172,$01 Read a byte from the built screen address in #REGbc.
  $D173,$01 Combine the screen low byte with the pixel table low byte.
  $D174,$01 Store the combined screen low byte in #REGl.
  $D175,$01 Exchange #REGhl with #REGde (entity record pointer back in #REGhl).
  $D176,$03 Write the screen address into the entity record.
  $D179,$01 Advance #REGhl to the attribute slot.
  $D17A,$01 Load the attribute address high byte from #REGd.
  $D17B,$03 Rotate the attribute page bits toward the low end three times.
  $D17E,$02,b$01 Mask to the attribute page bits.
  $D180,$02,b$01 Set the attribute area high byte.
  $D182,$01 Store the attribute address high byte in #REGd.
  $D183,$03 Write the attribute address into the entity record.
  $D186,$04 Step #REGhl back four bytes to the entity origin for drawing.
  $D18A,$03 Call #R$CC81.
  $D18D,$01 Step #REGhl to the end-of-record marker position.
  $D18E,$02 Write the record terminator #N$FF after this entity.
  $D190,$01 Advance #REGhl for the next list write.
  $D191,$01 Restore the enemy count from the stack.
  $D192,$01 Decrement the remaining enemies to spawn for this wave.
  $D193,$03 Loop back to #R$D104 if more enemies remain.
N $D196 All enemies spawned: write the entity list terminator and return.
@ $D196 label=Spawn_Primary_Wave_Enemies_Done
  $D196,$03 Load #R$D1A4 into #REGde.
  $D199,$03 Store the updated write pointer at #R$C509.
  $D19C,$03 Store the entity list terminator routine address #R$D1A4 at *#REGhl
. (low byte then high byte).
  $D19F,$01 Advance #REGhl past the stored pointer bytes.
  $D1A0,$02 Write the terminator byte (#N$FF) to the entity list.
  $D1A2,$01 Restore the wave definition pointer from the stack.
  $D1A3,$01 Return.
N $D1A4 Inline stub: resets the entity list pointer and returns. Used as the
. terminal routine address written into the entity list by the spawning routines.
@ $D1A4 label=Entity_List_Reset
  $D1A4,$03 Reset the entity list pointer to #R$6000.
  $D1A7,$01 Return.

c $D1A8 Advance RNG Seed
@ $D1A8 label=Advance_RNG_Seed
D $D1A8 Advances the linear congruential generator one step. The seed at #R$C4DC
. is updated using the recurrence seed = seed × #N$21 + #N$29 (multiply by 33,
. add 41), producing the next pseudo-random value. Called by #R$D1BF to
. generate each random byte during enemy spawning.
  $D1A8,$03 Load the current RNG seed from #R$C4DC.
  $D1AB,$01 Stash #REGbc on the stack.
  $D1AC,$05 Multiply the seed by #N$20 by shifting left five times.
  $D1B1,$05 Reload the original seed into #REGbc and add it (total factor: #N$21).
  $D1B6,$07 Add #N($0029,$04,$04) and store the new seed back to #R$C4DC.
  $D1BD,$02 Restore #REGbc and return.

c $D1BF Generate Random Byte
@ $D1BF label=Generate_Random_Byte
D $D1BF Produces a single pseudo-random byte by advancing the RNG seed via
. #R$D1A8 and XOR-mixing its two bytes. #REGhl is preserved. Called throughout
. the enemy spawning routines to pick random positions and directions.
  $D1BF,$04 Stash #REGhl and advance the RNG seed via #R$D1A8.
  $D1C3,$02 XOR-mix the seed high and low bytes to produce the random byte.
  $D1C5,$02 Restore #REGhl and return.
N $D1C7 Entity spawn handler stub, invoked by #R$C6DA during hit-testing. Stores
. the entity colour from #REGc and advances the entity pointer.
@ $D1C7 label=Entity_Spawn_Handler
  $D1C7,$04 Initialise the entity colour byte and advance the entity data pointer.
N $D1CB Secondary wave enemy spawn: reads the entity configuration from the wave
. definition pointed to by #REGhl, then spawns secondary entities (handler
. #N$CEDF) at random valid pixel positions on the playfield.
@ $D1CB label=Spawn_Wave_Enemies_Class2
  $D1CB,$04 Read the sprite type byte from the wave definition and store at
. #N$C425.
  $D1CF,$09 Copy the sprite type to #REGb, accumulate it into #R$C41C, and
. advance the definition pointer.
  $D1D8,$05 Read the direction byte from the definition and store at #N$C426.
  $D1DD,$0B Read the speed byte, store at #N$C427; set the initial animation
. frame pair at #R$C51B.
  $D1E8,$05 Advance past the definition data and stash the definition pointer;
. load the entity list write pointer from #R$C509.
  $D1ED,$05 Skip spawning if the enemy count is zero.
@ $D1F2 label=Spawn_Wave_Enemies_Class2_Loop
  $D1F2,$08 Stash the enemy count and write the secondary entity handler address
. #N$CEDF to the entity list.
  $D1FA,$03 Generate a random direction via #R$D1BF.
  $D1FD,$02,b$01 Mask to values 1–3.
  $D1FF,$02 Retry if the direction rolled zero.
  $D201,$05 Store the direction and set the initial entity state to #N$04.
  $D206,$03 Generate a random Y pixel position via #R$D1BF.
  $D209,$08 Retry if outside the playfield vertical range (#N$18–#N$A3).
  $D211,$02 Write the Y position and advance the entity pointer.
  $D213,$03 Generate a random X pixel position via #R$D1BF.
  $D216,$08 Retry if outside the playfield horizontal range (#N$08–#N$EE).
  $D21E,$07 Write the X position and the entity dimensions (#N$0C × #N$09).
  $D225,$08 Step back to the entity record origin and load the spawn handler
. #R$D1C7 into alternate #REGhl.
  $D22D,$03 Test whether this position overlaps an existing entity via #R$C6DA.
  $D230,$02 Jump to #R$D237 if the position is clear.
  $D232,$05 Step back and retry with a new X position.
@ $D237 label=Spawn_Wave_Enemies_Class2_Accept
  $D237,$04 Advance past the entity record and write the #N$FF end-of-record
. marker.
  $D23B,$03 Restore the enemy count and loop for the next secondary enemy.
@ $D23E label=Spawn_Wave_Enemies_Class2_Done
  $D23E,$0C Write the entity list return-routine address and the #N$FF sentinel;
. store the updated entity list write pointer at #R$C509.
  $D24A,$02 Restore the wave definition pointer and return.

c $D24C Stage Next Wave
@ $D24C label=Stage_Next_Wave
D $D24C Entry point for wave staging. Resets the entity list write pointer to
. #R$6100 and writes a terminator. If #R$C41C is non-zero the current wave set
. is re-populated (#R$D299); otherwise a fresh wave is loaded: enemy parameters
. are cleared, the next entry in the wave definition table (#R$C409) is read,
. the display is reinitialised via #R$D30C, and the main game loop is entered
. via #R$CB4F with the playfield entity handler #N$CE62 in place.
  $D24C,$03 Reset the entity list write pointer to #R$6100.
  $D24F,$0C Write the entity list terminator routine address #N$D1A4 and the
. #N$FF sentinel; store the updated write pointer at #R$C509.
  $D25B,$06 Check whether the wave counter at #R$C41C is non-zero; if so, jump
. to #R$D299 to re-populate the current wave set.
N $D261 New wave: clear enemy parameters, read the next wave definition entry,
. and reinitialise the display.
  $D261,$0D Clear the enemy parameter block at #R$C423 (#N$0C bytes) ready for
. the incoming wave.
  $D26E,$0A Read the new wave number from #R$C409 into #R$C408, then reinitialise
. the display via #R$D30C.
  $D278,$07 Advance the wave definition pointer in #R$C409 past the current entry
. via #R$C702.
  $D27F,$03 Store the updated wave definition pointer back to #R$C409.
@ $D282 label=Stage_Next_Wave_Activate
  $D282,$09 Point the playfield write pointer (#R$C4D1) to #R$6000 and write the
. playfield entity handler address #N$CE62 to the entity list.
  $D28B,$06 Write the #N$FF end-of-list sentinel after the handler address.
  $D291,$08 Set the wave active flag at #R$C4DE to #N$01 and jump to the main
. game loop at #R$CB4F.
N $D299 Re-populate: clear the wave counter, redraw the HUD, and spawn all enemy
. types for the current wave before restarting the game loop.
@ $D299 label=Stage_Next_Wave_Populate
  $D299,$07 Clear the wave counter at #R$C41C and redraw the HUD via #R$D317.
  $D2A0,$06 Call #R$D0F0 using #R$C423.
  $D2A6,$03 Spawn the secondary wave enemies via #R$D1CB.
  $D2A9,$03 Run the entity update pass via #R$E122.
  $D2AC,$03 Call #R$E290.
  $D2AF,$03 Call #R$E863.
  $D2B2,$03 Call #R$CE64.
  $D2B5,$03 Call #R$E92C.
  $D2B8,$04 Clear #REGa and restart the playfield via #R$D282.

c $D2BC Strip Attributes and Fade
@ $D2BC label=Strip_Attributes_And_Fade
D $D2BC Player-death transition. Strips the paper and bright bits from every
. attribute cell in the attribute area (#N$5800–#N$5AFF), keeping only the ink
. colour, then calls #R$D2D1 to fade the screen pixel data to black with a
. flashing border effect. On return, two levels of call stack are discarded
. via back-to-back POP #REGde, aborting the current game-loop callers and
. returning to the outer death-handling code.
  $D2BC,$03 Point #REGhl to the start of the attribute area at #N$5800.
  $D2BF,$02 Load the ink-colour mask #N$07 into #REGb.
@ $D2C1 label=Strip_Attributes_Loop
  $D2C1,$03 Mask out the paper and bright bits from the current attribute cell.
  $D2C4,$07 Advance to the next cell and loop until the end of the attribute
. area at #N$5B00.
  $D2CB,$03 Call the screen fade routine at #R$D2D1.
  $D2CE,$03 Discard two return addresses from the stack and return to the
. outer death handler.
N $D2D1 Screen fade: AND-masks the entire pixel area in 20 passes, cycling the
. border between black and white on each pass to create a flash effect.
@ $D2D1 label=Fade_Screen
  $D2D1,$02 Set the fade pass counter to #N$14.
  $D2D3,$03 Initialise the pixel mask pointer to #N$0000.
@ $D2D6 label=Fade_Screen_Outer_Loop
  $D2D6,$04 Stash the mask pointer and point #REGde to the start of the pixel
. area at #N$4000.
@ $D2DA label=Fade_Screen_Inner_Loop
  $D2DA,$09 AND each pixel byte with the corresponding mask byte; loop across
. the current 256-byte row until #REGe wraps.
  $D2E3,$04 Set the border to black (#INK$00) via port #N$FE.
  $D2E7,$05 Scale the pass counter for the delay loop duration.
@ $D2EC label=Fade_Screen_Black_Delay
  $D2EC,$03 Busy-wait for the black border period.
  $D2EF,$02 Load the white border value #N$18.
  $D2F1,$02,b$01 Mask to border bits only.
  $D2F3,$02 Set the border to white via port #N$FE.
  $D2F5,$05 Scale the pass counter for the second delay loop duration.
@ $D2FA label=Fade_Screen_White_Delay
  $D2FA,$03 Busy-wait for the white border period.
  $D2FD,$05 Continue masking screen rows until the full pixel area (#N$4000–
. #N$57FF) has been processed.
  $D302,$04 Restore the mask pointer, advance the mask page, and repeat for the
. next fade pass.
  $D306,$01 Return.
N $D307 Restore the border colour to white after the fade.
@ $D307 label=Restore_Border_White
  $D307,$05 Set the border to white (#INK$07) via port #N$FE and return.

c $D30C Clear Screen and Render HUD
@ $D30C label=Clear_Screen_And_Render_HUD
D $D30C Clears the screen buffer via #R$D070, sets a white background via
. #R$D07E, then jumps directly to #R$D325 to render scores and lives for
. both players. Called by #R$D24C at the start of each new wave. Unlike
. #R$D317 this skips redrawing the playfield border and attribute bar.
  $D30C,$03 Clear the screen buffer via #R$D070.
  $D30F,$05 Call #R$D07E using #INK$07.
  $D314,$03 Jump to #R$D325 to render the scores and lives.

c $D317 Render HUD
@ $D317 label=RenderHUD
D $D317 Clears the screen buffer, sets a white background, draws the playfield
. border (#R$D570), and redraws the attribute bar (#R$C713)
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
  $D382,$03 Call #R$DAA3.
  $D385,$03 Call #R$C713.
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

c $D486 Draw Life Icon Cells
@ $D486 label=Draw_Life_Icon_Cells
D $D486 Draws the life icon cell pixels into the display file. Given an icon
. index in #REGa, looks up the icon cell data address from the descriptor
. table, then for each cell computes the screen pixel address and OR-blits
. the icon pixels into the display file. Used by #R$C794 to repaint the
. lives display.
R $D486 A Icon index; selects the cell data from the icon descriptor table
  $D486,$04 Double the icon index to form a 16-bit table offset.
  $D48A,$04 Index into the icon descriptor table.
  $D48E,$04 Load the icon cell data address.
  $D492,$03 Set #REGde to the source data and load the cell count into #REGb.
@ $D495 label=Draw_Life_Icon_Cells_Loop
  $D495,$01 Stash the loop state on the stack.
  $D496,$05 Compute the pixel row for this icon cell.
  $D49B,$03 Compute the pixel column and stash the data pointer on the stack.
  $D49E,$07 Compute the row lookup address in #REGbc.
  $D4A5,$06 Compute the column lookup address in #REGhl.
  $D4AB,$04 Resolve the screen pixel address for this cell.
  $D4AF,$04 Combine the pixel row mask with the screen address.
  $D4B3,$03 OR the icon pixel data into the display file.
  $D4B6,$04 Restore the data pointer and loop state, and repeat for the next cell.
  $D4BA,$01 Return.

c $D4BB Erase Life Icon Cells
@ $D4BB label=Erase_Life_Icon_Cells
D $D4BB Clears the display file cells that make up one life icon. Mirrors
. the structure of #R$D486 but uses CPL and AND to erase each pixel cell
. rather than OR-blitting it. Given an icon index in #REGa, the routine
. looks up the cell data address, then for each cell computes the screen
. pixel address and removes the icon pixels.
R $D4BB A Icon index; selects the cell data from the icon descriptor table
  $D4BB,$04 Double the icon index to form a 16-bit table offset.
  $D4BF,$04 Index into the icon descriptor table.
  $D4C3,$04 Load the icon cell data address.
  $D4C7,$03 Set #REGde to the source data and load the cell count into #REGb.
@ $D4CA label=Erase_Life_Icon_Cells_Loop
  $D4CA,$01 Stash the loop state on the stack.
  $D4CB,$05 Compute the pixel row for this icon cell.
  $D4D0,$03 Compute the pixel column and stash the data pointer on the stack.
  $D4D3,$07 Compute the row lookup address in #REGbc.
  $D4DA,$06 Compute the column lookup address in #REGhl.
  $D4E0,$04 Resolve the screen pixel address for this cell.
  $D4E4,$04 Combine the pixel row mask with the screen address.
  $D4E8,$04 Erase the icon pixel data from the display file.
  $D4EC,$04 Restore the data pointer and loop state, and repeat for the next cell.
  $D4F0,$01 Return.

b $D4F1 Entity Type By Direction Table
@ $D4F1 label=Entity_Type_By_Direction_Table
D $D4F1 Sixteen entity type bytes, one per movement direction index. Indexed by
. the Y direction value from #R$C517 by #R$CB4F to select the entity type
. written into each newly spawned entity record.
B $D4F1,$10

b $D501 Intro Sprite Template
@ $D501 label=Intro_Sprite_Template
D $D501 Three four-byte entries used as the initial sprite state for
. #R$D50D. Copied to the working state at the start of each animation
. cycle by #R$D519. Each entry contains the sprite identifier at
. +#N$00, the initial Y-position at +#N$01, the initial X-position at
. +#N$02, and the X-velocity at +#N$03.
B $D501,$0C,$04

b $D50D Intro Sprite State
@ $D50D label=Intro_Sprite_State
D $D50D Working copy of #R$D501 updated each frame by #R$D52A.
. Y-positions advance by #N$06 per frame; X-positions accumulate
. their velocity values.
B $D50D,$0C,$04

c $D519 Animate Intro Screen Sprites
@ $D519 label=Animate_Intro_Screen_Sprites
D $D519 Controls a three-sprite scrolling animation on the intro screen.
. Entering at #R$D519 copies the sprite template to the working state
. and sets the frame counter to #N$0E. Entering at #R$D52A runs one
. frame: each sprite is rendered via #R$D794, its Y-position scrolled
. down by #N$06 and X-position advanced by its velocity. After #N$0E
. frames, a bright white closing sprite is drawn and the animation
. restarts.
  $D519,$09 Set up to copy the sprite template to the working state.
  $D522,$02 Copy the sprite template to the working sprite state.
  $D524,$05 Reset the animation frame counter to #N$0E.
  $D529,$01 Return.
@ $D52A label=Animate_Intro_Screen_Sprites_Step
  $D52A,$03 Point to the first sprite state entry.
  $D52D,$02 Set the sprite entry loop counter.
  $D52F,$03 Load the animation frame counter.
  $D532,$03 Stash the frame counter in the shadow register.
@ $D535 label=Animate_Intro_Screen_Sprites_Loop
  $D535,$02 Stash the sprite state pointer and loop counter on the stack.
  $D537,$03 Render this sprite via #R$D794.
  $D53A,$02 Restore the loop counter and state pointer from the stack.
  $D53C,$01 Advance past the sprite identifier byte.
  $D53D,$04 Scroll the Y-position down by #N$06 pixels.
  $D541,$06 Apply the X velocity to the X-position.
  $D547,$02 Advance to the next sprite state entry.
  $D549,$02 Repeat for the next sprite entry.
  $D54B,$07 Decrement the animation frame counter.
  $D552,$03 Return if the animation is still running.
N $D555 Final frame: draw the closing sprite with bright white and restart.
  $D555,$04 Set the closing sprite attribute to bright white.
  $D559,$06 Call #R$D637 using #R$C4D3.
  $D55F,$03 Reinitialise the animation and restart.

c $D562 Draw Playfield Border Row
@ $D562 label=DrawPlayfieldBorderRow
D $D562 Caller supplies the row in #REGl. Sweeps #REGh from #N$06 to #N$F9
. inclusive, calling #R$8D80 each time to OR the border glyph across that row
. of the screen buffer. Used only from #R$D570.
@ $D564 label=DrawPlayfieldBorderRow_Loop
  $D562,$02 #REGh=#N$06 (start of the horizontal sweep).
  $D564,$01 Stash #REGhl on the stack (coordinates for #R$8D80).
  $D565,$03 Call #R$8D80 (OR-blit at this cell).
  $D568,$01 Restore #REGhl from the stack.
  $D569,$01 Increment #REGh (next column in the sweep).
  $D56A,$05 Loop back to #R$D564 until the full row has been drawn.
  $D56F,$01 Return.

c $D570 Draw Playfield Border
@ $D570 label=DrawPlayfieldBorder
D $D570 Draws the rectangular border surrounding the play area. If the units
. digit of *#R$C408 is #N$09 the routine returns without drawing. Otherwise it
. draws full-width horizontal strips at rows #N$0E and #N$0F (top edge) via
. #R$D562, then for each row from #N$10 to #N$B7 it OR-blits columns #N$06,
. #N$07, #N$F8 and #N$F9 (left and right edges), and finally draws full-width
. strips at rows #N$B8 and #N$B9 (bottom edge) via #R$D562. Called from
. #R$C84F and #R$D317.
N $D570 #PUSHS #SIM(start=$D317,stop=$D5B0) #UDGTABLE {
.   #SCR$02(playfield-border)
. } TABLE# #POPS
  $D570,$03 #REGa=*#R$C408 (BCD wave number).
  $D573,$02,b$01 Keep the low decimal digit (AND #N$0F).
  $D575,$03 Return if the units digit is #N$09 (no border drawn).
  $D578,$05 Call #R$D562 to draw the top-edge strip at row #N$0E.
  $D57D,$05 Call #R$D562 to draw the top-edge strip at row #N$0F.
  $D582,$02 #REGl=#N$10 (top row of the framed block).
@ $D584 label=DrawPlayfieldBorder_SideColumns
N $D584 Left and right edges: for each row #N$10 to #N$B7, OR-blit columns
. #N$06, #N$07, #N$F8 and #N$F9 via #R$8D80.
  $D584,$02 #REGh=#N$06 (left inner column).
  $D586,$01 Stash #REGhl on the stack.
  $D587,$03 Call #R$8D80.
  $D58A,$01 Restore #REGhl from the stack.
  $D58B,$02 #REGh=#N$07 (left inner column + #N$01).
  $D58D,$01 Stash #REGhl on the stack.
  $D58E,$03 Call #R$8D80.
  $D591,$01 Restore #REGhl from the stack.
  $D592,$02 #REGh=#N$F8 (right inner column).
  $D594,$01 Stash #REGhl on the stack.
  $D595,$03 Call #R$8D80.
  $D598,$01 Restore #REGhl from the stack.
  $D599,$02 #REGh=#N$F9 (right inner column + #N$01).
  $D59B,$01 Stash #REGhl on the stack.
  $D59C,$03 Call #R$8D80.
  $D59F,$01 Restore #REGhl from the stack.
  $D5A0,$01 Increment #REGl (next row).
  $D5A1,$05 Loop back to #R$D584 until all rows are drawn.
  $D5A6,$05 Call #R$D562 to draw the bottom-edge strip at row #N$B8.
  $D5AB,$05 Call #R$D562 to draw the bottom-edge strip at row #N$B9.
  $D5B0,$01 Return.

c $D5B1 Remove Entity from List
@ $D5B1 label=Remove_Entity_From_List
D $D5B1 Removes the entity whose record is pointed to by #R$C4DA from the
. entity list. Steps back to the start of the entity's 12-byte record, then
. block-copies all subsequent records down by 12 bytes via LDIR, closing the
. gap. The entity list end pointer at #R$C4D1 is decremented by 12 to reflect
. the shorter list. Returns with #REGhl pointing to the record that now
. occupies the removed entity's slot.
  $D5B1,$03 Load the entity record pointer from #R$C4DA.
@ $D5B4 label=Remove_Entity_From_List_Step
  $D5B4,$05 Step back to the start of the entity record and save the updated
. pointer to #R$C4DA.
  $D5B9,$05 Compute the start of the next entity record (12 bytes ahead) in
. #REGde.
  $D5BE,$0A Load the entity list end pointer from #R$C4D1, subtract the
. destination address to get the copy byte count, and load that count into
. #REGbc.
  $D5C8,$06 Set source to the start of the next entity record and shift all
. remaining records down by 12 bytes via LDIR.
  $D5CE,$0E Decrement the entity list end pointer at #R$C4D1 by 12 bytes and
. return with #REGhl pointing to the new occupant of the vacated slot.
  $D5DC,$01 Return.
N $D5DD Entity movement handler, stored as the entity handler address in entity
. records that use the narrow sprite renderer. Applies the entity's velocity
. to its current screen position, validates that the new position lies within
. the playfield bounds, updates the entity record, and redraws the sprite. If
. the new position is out of bounds the entity is removed via #R$D5B1.
@ $D5DD label=Move_And_Redraw_Entity
  $D5DD,$03 Save the entity record pointer to #R$C4DA.
  $D5E0,$03 Erase the entity's current sprite via #R$C84F.
  $D5E3,$08 Reload the entity record from #R$C4DA and point #REGhl at the Y
. position field; copy the pointer to #REGde.
  $D5EB,$08 Advance #REGde to the Y velocity field and add the velocity to the
. current Y position.
  $D5F3,$04 Reject the move if the new Y position is above the playfield top
. edge (#N$10).
  $D5F7,$02 Reject the move if the new Y position is below the playfield bottom
. edge (#N$B8).
  $D5F9,$06 Store the new Y position; advance to the X fields and add the X
. velocity to the current X position.
  $D5FF,$02 Reject the move if the new X position is past the left edge
. (#N$08).
  $D601,$02 Remove the entity if the new X position is too close to the left
. wall.
  $D603,$02 Reject the move if the new X position is past the right edge
. (#N$F8).
  $D605,$02 Remove the entity if the new X position is too close to the right
. wall.
  $D607,$09 Store the new X position; step back and update the two additional
. entity record fields from their corresponding velocity bytes.
  $D610,$03 Update the final position field and step back to the entity record
. origin.
  $D613,$07 Set the entity colour to #COLOUR$47 in #REGb' and redraw the
. sprite via #R$C856.
  $D61A,$03 Reload the entity record pointer from #R$C4DA.
  $D61D,$03 Jump to the entity update completion handler at #R$CD13.

b $D620 Sprite Frame Table
@ $D620 label=Sprite_Frame_Table
D $D620 Sixteen sprite frame indices (one per movement direction) used by
. #R$CB4F to select the correct player sprite for the current direction.

c $D630 Erase Entity Sprite
@ $D630 label=Erase_Entity_Sprite
D $D630 Entry point for erasing an entity sprite. Sets erase mode then falls
. through to #R$D63B. In erase mode the attribute write is skipped.
  $D630,$04 Set erase mode (attribute write disabled).
  $D634,$03 Jump to #R$D63B.

c $D637 Draw Entity Sprite
@ $D637 label=Draw_Entity_Sprite
D $D637 Draws or erases an entity's sprite on the display. #R$D637 sets draw
. mode so the entity colour is written to the attribute area. #R$D630 sets
. erase mode and skips the attribute write. Both paths enter #R$D63B, which
. reads the entity type to look up sprite data from #R$C60C, computes the
. screen position from the Y and X bytes, then XOR-blends twelve pixel rows
. of sprite data onto the display.
R $D637 HL Entity record pointer
  $D637,$04 Set draw mode (attribute write enabled).
@ $D63B label=Draw_Entity_Sprite_Render
  $D63B,$02 Copy the entity record pointer to #REGbc.
  $D63D,$0C Look up the sprite data address for this entity type.
  $D649,$02 Copy the entity record pointer from #REGbc.
  $D64B,$05 Read the entity's Y position.
  $D650,$04 Double the Y position to form the pixel row address.
  $D654,$01 Stash the pixel row address on the stack.
  $D655,$0E Read the X position and extract the byte column and bit offset.
  $D663,$03 Save the pixel bit offset in the shadow register.
  $D666,$07 Compute the sprite pixel data address and add the column offset.
  $D66D,$02 Copy the sprite data pointer to #REGbc.
  $D66F,$01 Restore the pixel row address from the stack.
  $D670,$03 Read the pixel bit offset from the shadow register.
@ $D673 label=Draw_Entity_Sprite_Row1
N $D673 Render the sprite row by row. Each row XOR-blends two bytes of pixel
. data onto the display. After every seventh row the entity's colour is
. written to the screen attribute cells.
  $D673,$0F Blit the first sprite row onto the display.
  $D682,$07 Jump to #R$D698 if in erase mode (skip the attribute write).
  $D689,$04 Compute the attribute area address from the current screen row.
  $D68D,$02,b$01 Keep only the row address bits.
  $D68F,$02,b$01 Set the attribute memory flag.
  $D691,$07 Write the entity's colour to two attribute cells.
@ $D698 label=Draw_Entity_Sprite_Row2
  $D698,$13 Blit row two.
  $D6AB,$13 Blit row three.
  $D6BE,$13 Blit row four.
  $D6D1,$13 Blit row five.
  $D6E4,$13 Blit row six.
  $D6F7,$13 Blit row seven.
  $D70A,$07 Jump to #R$D720 if in erase mode (skip the attribute write).
  $D711,$04 Compute the attribute area address from the current screen row.
  $D715,$02,b$01 Keep only the row address bits.
  $D717,$02,b$01 Set the attribute memory flag.
  $D719,$07 Write the entity's colour to two attribute cells.
@ $D720 label=Draw_Entity_Sprite_Row8
  $D720,$13 Blit row eight.
  $D733,$13 Blit row nine.
  $D746,$13 Blit row ten.
  $D759,$13 Blit row eleven.
  $D76C,$13 Blit row twelve.
  $D77F,$05 Return if in erase mode (skip the final attribute write).
  $D784,$04 Compute the attribute area address from the current screen row.
  $D788,$02,b$01 Keep only the row address bits.
  $D78A,$02,b$01 Set the attribute memory flag.
  $D78C,$07 Write the entity's colour to two attribute cells.
  $D793,$01 Return.

c $D794 Draw Clipped Wide Sprite
@ $D794 label=Draw_Clipped_Wide_Sprite
D $D794 Draws a 2-byte-wide, 12-row entity sprite to the screen by
. toggling each row's pixel data against the existing screen content.
. Reads the sprite type and screen position from the entity record,
. looks up the pixel data address in #R$C60C, then renders twelve
. rows of two bytes each. Each row is bounds-checked against the play
. area (#N$10 top / #N$B9 bottom); rows outside the play area are
. skipped. Alternate registers carry the Y position and column offset
. across all twelve rows.
R $D794 HL Entity record pointer
  $D794,$03 Stash the entity record pointer in #REGbc and read the sprite type.
  $D797,$0B Double the sprite type and look up the pixel data address in #R$C60C.
  $D7A2,$03 Restore the entity record pointer and advance to the screen column
. byte.
  $D7A5,$08 Load the screen column, stash it in #REGd', and advance to
. the screen row byte.
  $D7AD,$04 Shift the column into the screen address high byte.
  $D7B1,$01 Stash the screen address high byte on the stack.
  $D7B2,$1E Load the screen row byte, extract the block-row bits via three right
. rotations, and combine with the column to build the screen address in #REGbc.
N $D7D0 Row 1: return if below the play area, skip if above, else draw.
  $D7D0,$03 Return if the entity's Y position is below the play area bottom
. (#N$B9).
  $D7D3,$04 Skip row 1 if above the play area top (#N$10).
  $D7D7,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D7EA label=Draw_Clipped_Wide_Sprite_Row2
N $D7EA Row 2: advance sprite data if skipped, step Y, step row table, draw.
  $D7EA,$02 Advance the sprite data pointer past the skipped row.
  $D7EC,$07 Advance Y by the row stride and decrement the step count.
@ $D7F3 label=Draw_Clipped_Wide_Sprite_Row2_Stride
  $D7F3,$05 Step #REGhl forward to the next pixel row.
  $D7F8,$06 Reload the Y position and return if below the play area bottom.
  $D7FE,$04 Skip row 2 if above the play area top.
  $D802,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D815 label=Draw_Clipped_Wide_Sprite_Row3
N $D815 Row 3: advance sprite data if skipped, step Y, step row table, draw.
  $D815,$02 Advance the sprite data pointer past the skipped row.
  $D817,$07 Advance Y by the row stride and decrement the step count.
@ $D81E label=Draw_Clipped_Wide_Sprite_Row3_Stride
  $D81E,$05 Step #REGhl forward to the next pixel row.
  $D823,$06 Reload the Y position and return if below the play area bottom.
  $D829,$04 Skip row 3 if above the play area top.
  $D82D,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D840 label=Draw_Clipped_Wide_Sprite_Row4
N $D840 Row 4: advance sprite data if skipped, step Y, step row table, draw.
  $D840,$02 Advance the sprite data pointer past the skipped row.
  $D842,$07 Advance Y by the row stride and decrement the step count.
@ $D849 label=Draw_Clipped_Wide_Sprite_Row4_Stride
  $D849,$05 Step #REGhl forward to the next pixel row.
  $D84E,$06 Reload the Y position and return if below the play area bottom.
  $D854,$04 Skip row 4 if above the play area top.
  $D858,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D86B label=Draw_Clipped_Wide_Sprite_Row5
N $D86B Row 5: advance sprite data if skipped, step Y, step row table, draw.
  $D86B,$02 Advance the sprite data pointer past the skipped row.
  $D86D,$07 Advance Y by the row stride and decrement the step count.
@ $D874 label=Draw_Clipped_Wide_Sprite_Row5_Stride
  $D874,$05 Step #REGhl forward to the next pixel row.
  $D879,$06 Reload the Y position and return if below the play area bottom.
  $D87F,$04 Skip row 5 if above the play area top.
  $D883,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D896 label=Draw_Clipped_Wide_Sprite_Row6
N $D896 Row 6: advance sprite data if skipped, step Y, step row table, draw.
  $D896,$02 Advance the sprite data pointer past the skipped row.
  $D898,$07 Advance Y by the row stride and decrement the step count.
@ $D89F label=Draw_Clipped_Wide_Sprite_Row6_Stride
  $D89F,$05 Step #REGhl forward to the next pixel row.
  $D8A4,$06 Reload the Y position and return if below the play area bottom.
  $D8AA,$04 Skip row 6 if above the play area top.
  $D8AE,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D8C1 label=Draw_Clipped_Wide_Sprite_Row7
N $D8C1 Row 7: crosses a character-cell boundary; the Y step doubles to
. advance to the next screen-third.
  $D8C1,$02 Advance the sprite data pointer past the skipped row.
  $D8C3,$09 Advance the Y position to the next character row boundary in
. alternate registers.
  $D8CC,$02 Adjust the loop counter for the double-height step.
@ $D8CE label=Draw_Clipped_Wide_Sprite_Row7_Stride
  $D8CE,$05 Step #REGhl forward to the next pixel row.
  $D8D3,$06 Reload the Y position and return if below the play area bottom.
  $D8D9,$04 Skip row 7 if above the play area top.
  $D8DD,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D8F0 label=Draw_Clipped_Wide_Sprite_Row8
N $D8F0 Row 8: advance sprite data if skipped, step Y, step row table, draw.
  $D8F0,$02 Advance the sprite data pointer past the skipped row.
  $D8F2,$07 Advance Y by the row stride and decrement the step count.
@ $D8F9 label=Draw_Clipped_Wide_Sprite_Row8_Stride
  $D8F9,$05 Step #REGhl forward to the next pixel row.
  $D8FE,$06 Reload the Y position and return if below the play area bottom.
  $D904,$04 Skip row 8 if above the play area top.
  $D908,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D91B label=Draw_Clipped_Wide_Sprite_Row9
N $D91B Row 9: advance sprite data if skipped, step Y, step row table, draw.
  $D91B,$02 Advance the sprite data pointer past the skipped row.
  $D91D,$07 Advance Y by the row stride and decrement the step count.
@ $D924 label=Draw_Clipped_Wide_Sprite_Row9_Stride
  $D924,$05 Step #REGhl forward to the next pixel row.
  $D929,$06 Reload the Y position and return if below the play area bottom.
  $D92F,$04 Skip row 9 if above the play area top.
  $D933,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D946 label=Draw_Clipped_Wide_Sprite_Row10
N $D946 Row 10: advance sprite data if skipped, step Y, step row table, draw.
  $D946,$02 Advance the sprite data pointer past the skipped row.
  $D948,$07 Advance Y by the row stride and decrement the step count.
@ $D94F label=Draw_Clipped_Wide_Sprite_Row10_Stride
  $D94F,$05 Step #REGhl forward to the next pixel row.
  $D954,$06 Reload the Y position and return if below the play area bottom.
  $D95A,$04 Skip row 10 if above the play area top.
  $D95E,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D971 label=Draw_Clipped_Wide_Sprite_Row11
N $D971 Row 11: advance sprite data if skipped, step Y, step row table, draw.
  $D971,$02 Advance the sprite data pointer past the skipped row.
  $D973,$07 Advance Y by the row stride and decrement the step count.
@ $D97A label=Draw_Clipped_Wide_Sprite_Row11_Stride
  $D97A,$05 Step #REGhl forward to the next pixel row.
  $D97F,$06 Reload the Y position and return if below the play area bottom.
  $D985,$04 Skip row 11 if above the play area top.
  $D989,$13 Compute the screen address and toggle the sprite row's two
. pixel bytes onto the screen.
@ $D99C label=Draw_Clipped_Wide_Sprite_Row12
N $D99C Row 12 (final): advance sprite data if skipped, step Y, step row
. table, draw and return.
  $D99C,$02 Advance the sprite data pointer past the skipped row.
  $D99E,$07 Advance Y by the row stride and decrement the step count.
@ $D9A5 label=Draw_Clipped_Wide_Sprite_Row12_Stride
  $D9A5,$05 Step #REGhl forward to the next pixel row.
  $D9AA,$06 Reload the Y position and return if below the play area bottom.
  $D9B0,$03 Return if row 12 is above the play area top.
  $D9B3,$11 Compute the screen address, toggle the sprite row's two pixel
. bytes onto the screen, and return.

c $D9C4 Initialise Entity State
@ $D9C4 label=Initialise_Entity_State
D $D9C4 Activates an entity state effect by copying a 16-byte
. configuration record from #R$D9EA into the active state slot at
. #R$C521. The entity type code in #REGe selects the record
. (multiplied by #N$10). If #R$C52F is zero, no effect is pending
. and the routine returns immediately without change.
R $D9C4 E Entity type code
  $D9C4,$05 Return if no entity state effect is pending.
  $D9C9,$0A Multiply the entity type code by #N$10 to form the
. record offset.
  $D9D3,$07 Index into #R$D9EA by offset and set #REGde to #R$C521.
  $D9DA,$05 Copy the #N$10-byte effect record to #R$C521.
  $D9DF,$01 Return.

c $D9E0 Dispatch Entity State Handler
@ $D9E0 label=Dispatch_Entity_State_Handler
D $D9E0 Called once per frame by the main game loop at #R$CB4F. Reads the state
. flag at #R$C52F; if #N$02 (complete) returns immediately. Otherwise loads
. the dispatch pointer from #R$C521 and jumps through it to the active entity
. state handler.
  $D9E0,$06 Return if the entity state is complete (#N$02).
  $D9E6,$04 Load the entity state dispatch pointer from #R$C521 and jump
. through it.

b $D9EA Entity State Table
@ $D9EA label=Entity_State_Table
D $D9EA Table of 16-byte entity state records indexed by entity type. Each entry
. is copied to #N$C521 by #R$D9C4 on entity placement. The first two bytes of
. each record form the dispatch handler address used by #R$D9E0; the remaining
. 14 bytes are parameters for the active effect.
B $D9EA,$40

c $DA2A Cycle Border from Screen
@ $DA2A label=Cycle_Border_From_Screen
D $DA2A Drives the per-frame border colour cycling effect. Reads successive pixel
. bytes from the screen buffer pointer at #N$C523, ANDs each byte with #N$18
. to extract the paper colour bits, and writes the result to the border port
. #N$FE. Between each byte a variable delay is run, its period advanced by the
. step value at #N$C52B. After the outer loop the frame counter at #N$C527 is
. decremented; when it reaches the threshold at #N$C52D, #R$C52F is set to
. #N$01 (step complete). When the frame counter reaches zero, #R$C52F is set
. to #N$02 (all complete). The alternate entry at #R$DA6B drives the same
. counter machinery without sampling screen data, instead XOR-toggling the
. border between two colours.
  $DA2A,$06 Load the screen data pointer from #N$C523 and the outer loop count
. from #N$C529 into #REGb.
@ $DA31 label=Cycle_Border_Loop
  $DA31,$03 Read the next pixel byte, mask to paper bits with #N$18, and write
. to the border port #N$FE.
  $DA36,$01 Advance the screen data pointer.
  $DA37,$04 Load the current delay count from #N$C525 into #REGc.
@ $DA3B label=Cycle_Border_Delay
  $DA3B,$03 Busy-wait for the delay period.
  $DA3E,$08 Reload #REGc, add the step increment from #N$C52B, and store the
. updated delay back to #N$C525.
  $DA46,$02 Loop back to #R$DA31 for the next pixel byte.
  $DA48,$03 Save the updated screen data pointer back to #N$C523.
  $DA4B,$06 Decrement the frame counter at #N$C527 and jump to #R$DA60 if it
. has reached zero.
  $DA51,$09 Save the decremented frame counter; return if it has not yet reached
. the completion threshold at #N$C52D.
  $DA5A,$06 Set #R$C52F to #N$01 (step complete) and return.
@ $DA60 label=Cycle_Border_Complete
  $DA60,$06 Set #R$C52F to #N$02 (all complete) and return.
N $DA66 Alternate entry: toggle the border colour on each pass without reading
. screen data.
@ $DA66 label=Cycle_Border_Toggle
  $DA66,$05 Load the outer loop count from #N$C529 into #REGb and clear #REGa.
@ $DA6B label=Cycle_Border_Toggle_Loop
  $DA6B,$02,b$01 XOR the border value with #N$18 to toggle between two colours.
  $DA6D,$03 Write the toggled value to the border port #N$FE and stash it in
. #REGd.
  $DA70,$04 Load the delay count from #N$C525 into #REGc.
@ $DA74 label=Cycle_Border_Toggle_Delay
  $DA74,$03 Busy-wait for the delay period.
  $DA77,$08 Reload #REGc, add the step increment from #N$C52B, and store the
. updated delay back to #N$C525.
  $DA7F,$03 Reload the toggled border value from #REGd and loop back to
. #R$DA6B.
  $DA82,$06 Decrement the frame counter at #N$C527 and jump to #R$DA60 if it
. has reached zero.
  $DA88,$09 Save the decremented frame counter; return if it has not yet reached
. the completion threshold at #N$C52D.
  $DA91,$06 Set #R$C52F to #N$01 (step complete) and return.

c $DA97 Delay Short
@ $DA97 label=Delay_Short
D $DA97 Busy-wait delay: outer loop of #N$0A iterations, inner loop of #N$00
. (256 cycles) each. Stashes and restores #REGbc.
  $DA97,$01 Stash #REGbc on the stack.
  $DA98,$02 #REGc=#N$0A (outer loop counter).
@ $DA9A label=Delay_Short_OuterLoop
@ $DA9C label=Delay_Short_InnerLoop
  $DA9A,$04 Inner loop: spin #REGb from #N$00 (256 iterations per pass).
  $DA9E,$03 Decrease outer counter and loop back to #R$DA9A until zero.
  $DAA1,$01 Restore #REGbc from the stack.
  $DAA2,$01 Return.

c $DAA3 Delay Long
@ $DAA3 label=Delay_Long
D $DAA3 Busy-wait delay: outer loop of #N$3C iterations, inner loop of #N$00
. (256 cycles) each. Stashes and restores #REGbc.
  $DAA3,$01 Stash #REGbc on the stack.
  $DAA4,$02 #REGc=#N$3C (outer loop counter).
@ $DAA6 label=Delay_Long_OuterLoop
@ $DAA8 label=Delay_Long_InnerLoop
  $DAA6,$04 Inner loop: spin #REGb from #N$00 (256 iterations per pass).
  $DAAA,$03 Decrease outer counter and loop back to #R$DAA6 until zero.
  $DAAD,$01 Restore #REGbc from the stack.
  $DAAE,$01 Return.

c $DAAF Draw Wide Entity Sprite
@ $DAAF label=Draw_Wide_Entity_Sprite_Pixels_Only
D $DAAF Draws a 3-byte-wide, 16-row entity sprite to the screen by
. toggling each row's pixel data against the existing screen content.
. Applying this routine twice draws and then erases a sprite, leaving
. the screen unchanged. Row screen addresses come from the row address
. lookup table at #R$C60C, offset by the entity's column position.
. Rows outside the play area (#N$10 top / #N$B0 bottom) are skipped.
. Called to draw and erase entity sprites during normal gameplay and
. death animations.
R $DAAF HL Entity record pointer
N $DAAF Read the sprite data pointer and compute the screen address origin.
  $DAAF,$02 Stash the entity record pointer in #REGbc.
  $DAB1,$0C Read the entity type, double it as an index into #R$C60C, and
. load the sprite data pointer into #REGde.
  $DABD,$03 Restore the entity record pointer and advance to the Y field.
  $DAC0,$07 Load row stride #N$46 into #REGb, read the entity Y position,
. and save it in #REGd'.
  $DAC7,$04 Scale the Y position into the row address table range.
  $DACB,$01 Stash the scaled Y and row stride on the stack.
  $DACC,$0F Read the X position and derive the column address via
. three-step rotation.
  $DADB,$03 Save the sub-column pixel offset in #REGc'.
  $DADE,$08 Adjust the column address to align with two-byte row table
. entries.
  $DAE6,$03 Combine the column address with the sprite data pointer and
. move the result to #REGbc.
  $DAE9,$01 Restore the scaled Y position from the stack.
  $DAEA,$03 Retrieve the entity Y position from #REGd'.
  $DAED,$03 Return if the entity is below the play area.
N $DAF0 Row 0: skip if above the play area, compute screen address, draw.
  $DAF0,$04 Skip row 0 if the entity is above the play area.
  $DAF4,$03 Load the column pixel offset from #REGc'.
  $DAF7,$05 Add the column offset to the row address and load the screen
. address into #REGde.
  $DAFC,$01 Exchange #REGde and #REGhl to point at the screen address.
  $DAFD,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DB0A,$01 Restore #REGhl to the row address table pointer.
  $DB0B,$02 Step the sprite data pointer back two bytes to the row start.
@ $DB0D label=Draw_Wide_Entity_Sprite_Pixels_Only_Row1
N $DB0D Row 1: advance sprite data, step Y, walk address table, draw.
  $DB0D,$03 Advance the sprite data pointer to row 1.
  $DB10,$07 Advance Y by the row stride and decrement the step count.
@ $DB17 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row1_Step
  $DB17,$05 Step #REGhl through the row address table.
  $DB1C,$06 Retrieve Y; return if below the play area.
  $DB22,$04 Skip row 1 if above the play area.
  $DB26,$09 Load the column offset and compute the screen address.
  $DB2F,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DB3C,$03 Restore the row table pointer and step back the sprite data.
@ $DB3F label=Draw_Wide_Entity_Sprite_Pixels_Only_Row2
N $DB3F Row 2: advance sprite data, step Y, walk address table, draw.
  $DB3F,$03 Advance the sprite data pointer to row 2.
  $DB42,$07 Advance Y by the row stride and decrement the step count.
@ $DB49 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row2_Step
  $DB49,$05 Step #REGhl through the row address table.
  $DB4E,$06 Retrieve Y; return if below the play area.
  $DB54,$04 Skip row 2 if above the play area.
  $DB58,$09 Load the column offset and compute the screen address.
  $DB61,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DB6E,$03 Restore the row table pointer and step back the sprite data.
@ $DB71 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row3
N $DB71 Row 3: advance sprite data, step Y, walk address table, draw.
  $DB71,$03 Advance the sprite data pointer to row 3.
  $DB74,$07 Advance Y by the row stride and decrement the step count.
@ $DB7B label=Draw_Wide_Entity_Sprite_Pixels_Only_Row3_Step
  $DB7B,$05 Step #REGhl through the row address table.
  $DB80,$06 Retrieve Y; return if below the play area.
  $DB86,$04 Skip row 3 if above the play area.
  $DB8A,$09 Load the column offset and compute the screen address.
  $DB93,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DBA0,$03 Restore the row table pointer and step back the sprite data.
@ $DBA3 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row4
N $DBA3 Row 4: advance sprite data, step Y, walk address table, draw.
  $DBA3,$03 Advance the sprite data pointer to row 4.
  $DBA6,$07 Advance Y by the row stride and decrement the step count.
@ $DBAD label=Draw_Wide_Entity_Sprite_Pixels_Only_Row4_Step
  $DBAD,$05 Step #REGhl through the row address table.
  $DBB2,$06 Retrieve Y; return if below the play area.
  $DBB8,$04 Skip row 4 if above the play area.
  $DBBC,$09 Load the column offset and compute the screen address.
  $DBC5,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DBD2,$03 Restore the row table pointer and step back the sprite data.
@ $DBD5 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row5
N $DBD5 Row 5: advance sprite data, step Y, walk address table, draw.
  $DBD5,$03 Advance the sprite data pointer to row 5.
  $DBD8,$07 Advance Y by the row stride and decrement the step count.
@ $DBDF label=Draw_Wide_Entity_Sprite_Pixels_Only_Row5_Step
  $DBDF,$05 Step #REGhl through the row address table.
  $DBE4,$06 Retrieve Y; return if below the play area.
  $DBEA,$04 Skip row 5 if above the play area.
  $DBEE,$09 Load the column offset and compute the screen address.
  $DBF7,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DC04,$03 Restore the row table pointer and step back the sprite data.
@ $DC07 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row6
N $DC07 Row 6: advance sprite data, step Y, walk address table, draw.
  $DC07,$03 Advance the sprite data pointer to row 6.
  $DC0A,$07 Advance Y by the row stride and decrement the step count.
@ $DC11 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row6_Step
  $DC11,$05 Step #REGhl through the row address table.
  $DC16,$06 Retrieve Y; return if below the play area.
  $DC1C,$04 Skip row 6 if above the play area.
  $DC20,$09 Load the column offset and compute the screen address.
  $DC29,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DC36,$03 Restore the row table pointer and step back the sprite data.
@ $DC39 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row7
N $DC39 Row 7: advance sprite data, step Y, walk address table, draw.
  $DC39,$03 Advance the sprite data pointer to row 7.
  $DC3C,$07 Advance Y by the row stride and decrement the step count.
@ $DC43 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row7_Step
  $DC43,$05 Step #REGhl through the row address table.
  $DC48,$06 Retrieve Y; return if below the play area.
  $DC4E,$04 Skip row 7 if above the play area.
  $DC52,$09 Load the column offset and compute the screen address.
  $DC5B,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DC68,$03 Restore the row table pointer and step back the sprite data.
@ $DC6B label=Draw_Wide_Entity_Sprite_Pixels_Only_Row8
N $DC6B Row 8: advance sprite data, step Y, walk address table, draw.
  $DC6B,$03 Advance the sprite data pointer to row 8.
  $DC6E,$07 Advance Y by the row stride and decrement the step count.
@ $DC75 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row8_Step
  $DC75,$05 Step #REGhl through the row address table.
  $DC7A,$06 Retrieve Y; return if below the play area.
  $DC80,$04 Skip row 8 if above the play area.
  $DC84,$09 Load the column offset and compute the screen address.
  $DC8D,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DC9A,$03 Restore the row table pointer and step back the sprite data.
@ $DC9D label=Draw_Wide_Entity_Sprite_Pixels_Only_Row9
N $DC9D Row 9: advance sprite data, step Y, walk address table, draw.
  $DC9D,$03 Advance the sprite data pointer to row 9.
  $DCA0,$07 Advance Y by the row stride and decrement the step count.
@ $DCA7 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row9_Step
  $DCA7,$05 Step #REGhl through the row address table.
  $DCAC,$06 Retrieve Y; return if below the play area.
  $DCB2,$04 Skip row 9 if above the play area.
  $DCB6,$09 Load the column offset and compute the screen address.
  $DCBF,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DCCC,$03 Restore the row table pointer and step back the sprite data.
@ $DCCF label=Draw_Wide_Entity_Sprite_Pixels_Only_Row10
N $DCCF Row 10: advance sprite data, step Y, walk address table, draw.
  $DCCF,$03 Advance the sprite data pointer to row 10.
  $DCD2,$07 Advance Y by the row stride and decrement the step count.
@ $DCD9 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row10_Step
  $DCD9,$05 Step #REGhl through the row address table.
  $DCDE,$06 Retrieve Y; return if below the play area.
  $DCE4,$04 Skip row 10 if above the play area.
  $DCE8,$09 Load the column offset and compute the screen address.
  $DCF1,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DCFE,$03 Restore the row table pointer and step back the sprite data.
@ $DD01 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row11
N $DD01 Row 11: advance sprite data, step Y, walk address table, draw.
  $DD01,$03 Advance the sprite data pointer to row 11.
  $DD04,$07 Advance Y by the row stride and decrement the step count.
@ $DD0B label=Draw_Wide_Entity_Sprite_Pixels_Only_Row11_Step
  $DD0B,$05 Step #REGhl through the row address table.
  $DD10,$06 Retrieve Y; return if below the play area.
  $DD16,$04 Skip row 11 if above the play area.
  $DD1A,$09 Load the column offset and compute the screen address.
  $DD23,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DD30,$03 Restore the row table pointer and step back the sprite data.
@ $DD33 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row12
N $DD33 Row 12: advance sprite data, step Y, walk address table, draw.
  $DD33,$03 Advance the sprite data pointer to row 12.
  $DD36,$07 Advance Y by the row stride and decrement the step count.
@ $DD3D label=Draw_Wide_Entity_Sprite_Pixels_Only_Row12_Step
  $DD3D,$05 Step #REGhl through the row address table.
  $DD42,$06 Retrieve Y; return if below the play area.
  $DD48,$04 Skip row 12 if above the play area.
  $DD4C,$09 Load the column offset and compute the screen address.
  $DD55,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DD62,$03 Restore the row table pointer and step back the sprite data.
@ $DD65 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row13
N $DD65 Row 13: advance sprite data, step Y, walk address table, draw.
  $DD65,$03 Advance the sprite data pointer to row 13.
  $DD68,$07 Advance Y by the row stride and decrement the step count.
@ $DD6F label=Draw_Wide_Entity_Sprite_Pixels_Only_Row13_Step
  $DD6F,$05 Step #REGhl through the row address table.
  $DD74,$06 Retrieve Y; return if below the play area.
  $DD7A,$04 Skip row 13 if above the play area.
  $DD7E,$09 Load the column offset and compute the screen address.
  $DD87,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DD94,$03 Restore the row table pointer and step back the sprite data.
@ $DD97 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row14
N $DD97 Row 14: advance sprite data, step Y, walk address table, draw.
  $DD97,$03 Advance the sprite data pointer to row 14.
  $DD9A,$07 Advance Y by the row stride and decrement the step count.
@ $DDA1 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row14_Step
  $DDA1,$05 Step #REGhl through the row address table.
  $DDA6,$06 Retrieve Y; return if below the play area.
  $DDAC,$04 Skip row 14 if above the play area.
  $DDB0,$09 Load the column offset and compute the screen address.
  $DDB9,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DDC6,$03 Restore the row table pointer and step back the sprite data.
@ $DDC9 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row15
N $DDC9 Row 15: advance sprite data, step Y, walk address table, draw.
  $DDC9,$03 Advance the sprite data pointer to row 15.
  $DDCC,$07 Advance Y by the row stride and decrement the step count.
@ $DDD3 label=Draw_Wide_Entity_Sprite_Pixels_Only_Row15_Step
  $DDD3,$05 Step #REGhl through the row address table.
  $DDD8,$06 Retrieve Y; return if below the play area.
  $DDDE,$03 Return if the entity is above the play area.
  $DDE1,$09 Load the column offset and compute the screen address.
  $DDEA,$0D Toggle the sprite row's three pixel bytes onto the screen.
  $DDF7,$01 Restore #REGhl to the row address table pointer.
  $DDF8,$01 Return.

b $DDF9 Bytes After Wide Sprite Draw
@ $DDF9 label=Trailing_Rom_After_Wide_Draw
D $DDF9 ROM after #R$DAAF. SkoolKit prints instructions from raw bytes here.
. They are not one runnable routine after #R$DDF8.
. #R$C519 defaults to #N$DDF9 until staging fills it from #R$D3E4.
B $DDF9,$20A

c $E003 Process Entity Record
@ $E003 label=Process_Entity_Record_Fast
D $E003 Processes one entity slot in the wave entity list. If the slot is
. active, the enemy's animation colours are updated on screen via #R$CFA4
. and its animation counter decremented. If the counter expires the enemy
. is erased and the slot retired. If the slot holds spawn data (#R$E031),
. a new enemy position is found and the enemy is placed in the play area.
R $E003 HL Pointer to the entity type/state byte
  $E003,$01 Read the entity's animation counter.
  $E004,$03 Jump to #R$E00C.
@ $E007 label=Process_Entity_Record
  $E007,$01 Read the entity's animation counter.
  $E008,$04 Jump to #R$E031 if the entity slot is inactive.
@ $E00C label=Process_Entity_Record_Tick
N $E00C Update the enemy's on-screen colour then advance its animation counter.
. If the counter expires the enemy is erased.
  $E00C,$02,b$01 Extract the three-bit animation frame number.
  $E00E,$01 Move past the animation counter byte.
  $E00F,$01 Stash the entity data pointer on the stack.
  $E010,$03 Pass the animation frame number to the colouring routine.
  $E013,$03 Call #R$CFA4 to colour the entity on screen.
  $E016,$01 Restore the entity data pointer from the stack.
  $E017,$01 Step back to the animation counter byte.
  $E018,$04 Advance the animation frame and jump to #R$E02C if not yet expired.
N $E01C The animation counter has run down to zero: remove the enemy from
. the screen.
  $E01C,$01 Move past the animation counter byte.
  $E01D,$01 Stash the entity data pointer on the stack.
  $E01E,$03 Call #R$D630 to erase the enemy sprite from the screen.
  $E021,$01 Restore the entity data pointer from the stack.
  $E022,$03 Step back to the entity handler address field.
  $E025,$03 Load #R$E02C as the replacement entity handler.
  $E028,$04 Write #R$E02C into the entity handler address field.
@ $E02C label=Process_Entity_Record_Next7
  $E02C,$05 Skip to the next entity record and return.
@ $E031 label=Process_Entity_Record_Inactive
N $E031 This slot holds spawn data for a new enemy. Erase any ghost at the
. target position, check it falls within the play area, then try to
. place the enemy.
  $E031,$01 Move past the animation counter byte.
  $E032,$01 Stash the entity data pointer on the stack.
  $E033,$03 Call #R$C949 to erase any residual sprite at the spawn position.
  $E036,$01 Restore the entity data pointer from the stack.
  $E037,$01 Move to the entity's Y position.
  $E038,$05 Set the play area boundary data address for the bounds check.
  $E03D,$03 Call #R$C6DA to test if the spawn position is within the play area.
  $E040,$03 Jump to #R$E0B7 if the position is outside the play area.
  $E043,$03 Step back to the entity type state byte.
  $E046,$03 Call #R$D1BF to determine whether the enemy should change type.
  $E049,$05 Stay with the current enemy type if the random roll is below #N$F0.
@ $E04E label=Process_Entity_Record_Cycle_Type
  $E04E,$01 Step back to the entity type state byte.
  $E04F,$01 Read the entity type state.
  $E050,$01 Advance to the next animation variant.
  $E051,$02,b$01 Wrap within the valid entity type range (#N$33).
  $E053,$01 Save the new entity type state.
  $E054,$01 Move to the entity's animation frame data.
  $E055,$03 Jump to #R$E05B.
@ $E058 label=Process_Entity_Record_Keep_Type
N $E058 The random roll was below #N$F0 so the enemy keeps its current type.
. Load the unchanged type state and fall through to apply a movement step.
  $E058,$01 Step back to the entity type state byte.
  $E059,$01 Read the entity type state.
  $E05A,$01 Move to the entity's animation frame data.
@ $E05B label=Process_Entity_Record_Apply_Delta
N $E05B Apply a one-step movement from the direction table at #R$E11A. The
. direction is derived from the low two bits of the entity type state.
  $E05B,$01 Preserve the entity data pointer in #REGde.
  $E05C,$02,b$01 Isolate the movement direction (two bits).
  $E05E,$09 Index into the direction delta table at #R$E11A.
  $E067,$01 Restore #REGhl to the entity data and #REGde to the delta entry.
  $E068,$02 Apply the Y movement delta to the enemy's current Y position.
  $E06A,$05 Retry with a new type if the enemy moves below the play area.
  $E06F,$05 Retry with a new type if the enemy moves above the play area.
  $E074,$01 Save the validated Y position.
  $E075,$02 Advance to the enemy's X position and the X delta.
  $E077,$02 Apply the X movement delta to the enemy's current X position.
  $E079,$05 Jump to #R$E083 if the new X overshoots the right edge.
  $E07E,$05 Accept the position if it is within the play area's left boundary.
@ $E083 label=Process_Entity_Record_Retry
  $E083,$01 Step back to the Y delta entry.
  $E084,$03 Retry with a new enemy type.
@ $E087 label=Process_Entity_Record_Register
N $E087 The enemy's new position is inside the play area. Write it to the
. record and draw the enemy on screen.
  $E087,$04 Write the new screen position into the entity record.
  $E08B,$01 Stash the entity record pointer on the stack.
  $E08C,$04 Set the spawn display attribute (#COLOUR$47) in the shadow register.
  $E090,$03 Call #R$C950 to spawn the enemy and draw it on screen.
  $E093,$01 Restore the entity record pointer from the stack.
@ $E094 label=Process_Entity_Record_Next6
  $E094,$05 Skip to the next entity record and return.
@ $E099 label=Process_Entity_Record_Counter_Up_Next6
N $E099 The enemy was placed successfully. Increment the scroll position
. counter before advancing to the next record.
  $E099,$01 Preserve the entity list pointer in #REGde.
  $E09A,$0A Add #N$0040 to *#N$C535.
  $E0A4,$01 Restore the entity list pointer.
  $E0A5,$03 Jump to #R$E094.
@ $E0A8 label=Process_Entity_Record_Counter_Up_Next7
N $E0A8 Same as #R$E099 but steps over a seven-byte record.
  $E0A8,$01 Preserve the entity list pointer in #REGde.
  $E0A9,$0A Add #N$0040 to *#N$C535.
  $E0B3,$01 Restore the entity list pointer.
  $E0B4,$03 Jump to #R$E02C.
@ $E0B7 label=Process_Entity_Record_Kill
N $E0B7 The enemy has left the play area. Flash it with its death sprite then
. add a kill bonus to the player's score.
  $E0B7,$05 Rewind to the entity handler address field.
  $E0BC,$02 Switch the entity to the kill sequence handler.
  $E0BE,$01 Move to the entity colour attribute byte.
  $E0BF,$01 Read the entity colour attribute.
  $E0C0,$01 Stash the entity colour attribute on the stack.
  $E0C1,$06 Set the entity's death colour from the current kill tally.
  $E0C7,$01 Stash the attribute pointer on the stack.
  $E0C8,$04 Set the death flash attribute (#INK$07) in the shadow register.
  $E0CC,$03 Call #R$D637 to draw the entity's death animation sprite.
  $E0CF,$01 Restore the attribute pointer from the stack.
  $E0D0,$03 Read the enemy kill value from the wave counter.
  $E0D3,$08 Multiply by #N$10 for the score contribution.
  $E0DB,$01 Save the entity pointer while accessing the score.
  $E0DC,$03 Point #REGhl at the player's score.
  $E0DF,$03 Add the kill score to the ones digit of the player's score (BCD).
  $E0E2,$03 Jump to #R$E0F4 if the ones digit did not overflow.
  $E0E5,$01 Move to the tens digit.
  $E0E6,$05 Carry one into the tens digit of the player's score (BCD).
  $E0EB,$03 Jump to #R$E0F4 if the tens digit did not overflow.
  $E0EE,$01 Move to the hundreds digit.
  $E0EF,$05 Carry one into the hundreds digit of the player's score (BCD).
@ $E0F4 label=Process_Entity_Record_Wave_Count
  $E0F4,$08 Jump to #R$E100 if the maximum kill count for this wave is reached.
  $E0FC,$04 Increment the wave kill counter.
@ $E100 label=Process_Entity_Record_Decrement_Count
  $E100,$01 Restore the entity colour attribute from the stack.
  $E101,$09 Extract the entity type to use as a count table index.
  $E10A,$06 Form a pointer to the entity count entry for this type.
  $E110,$01 Decrement the on-screen enemy count for this type.
  $E111,$01 Restore the entity list pointer.
  $E112,$01 Stash the entity list pointer on the stack.
  $E113,$03 Call #R$CD34 to update the score and wave display.
  $E116,$01 Restore the entity list pointer from the stack.
  $E117,$03 Jump to #R$E094.
@ $E11A label=Direction_Delta_Table
N $E11A Movement delta table: one two-byte entry (Y delta, X delta) per
. cardinal direction, indexed by the low two bits of the entity type
. state. Order: up, right, down, left.
B $E11A,$08,$02

c $E122 Spawn Wave Enemies
@ $E122 label=Spawn_Wave_Enemies
D $E122 Reads three spawn-count bytes from #REGhl (slots #N$10, #N$20, #N$30)
. and populates the entity list at *#R$C50D with entities via #R$E149. Each
. record has a random screen position and a slot-typed variant; #R$C950 spawns
. each entity. Terminates the list with #N$D1A4 and updates *#R$C509.
  $E122,$04 #REGde=*#R$C509 (current entity list write pointer).
  $E126,$08 Copy #REGde to *#R$C50D and *#R$C50B.
  $E12E,$05 Call #R$E149 with enemy slot #N$10.
  $E133,$05 Call #R$E149 with enemy slot #N$20.
  $E138,$05 Call #R$E149 with enemy slot #N$30.
  $E13D,$04 Save the final entity list write pointer to *#R$C509.
  $E141,$06 Write the entity list terminator #N$D1A4 to *#REGhl.
  $E147,$01 Restore #REGhl and #REGde.
  $E148,$01 Return.
@ $E149 label=Spawn_Wave_Enemies_Populate_Slot
N $E149 Reads the count byte from *#REGhl. Caches it in the entity count table
. at #R$C41E(#N$C427)+index. If zero, jumps to #R$E1AF; otherwise loops
. #REGb times, writing a nine-byte entity record and calling #R$C950.
  $E149,$01 Stash the source pointer on the stack.
  $E14A,$01 #REGd=*#REGhl (entity count for this slot).
  $E14B,$01 Save the slot ID in #REGa.
  $E14C,$08 Shift #REGc right four times to derive the slot count table index.
  $E154,$07 Write entity count (#REGd) to *#R$C41E(#N$C427)+index.
  $E15B,$01 Restore the source pointer.
  $E15C,$01 #REGc=#REGa (restore the slot ID).
  $E15D,$02 #REGa=#REGb=entity count (#REGb drives the entity spawn loop).
  $E15F,$01 Test if the entity count is zero.
  $E160,$01 Stash the source pointer on the stack.
  $E161,$03 #REGhl=*#R$C50D (entity list write pointer).
  $E164,$03 Jump to #R$E1AF if the entity count is zero.
@ $E167 label=Spawn_Wave_Enemies_Write_Record
N $E167 Build one entity record at *#REGhl: entity handler #N$E007, zero byte,
. type nibble, random Y (#N$10-#N$AA), random X (#N$08-#N$F0), then
. #N$0D, #N$07, #N$FF; call #R$C950 to spawn. Loop #REGb times.
  $E167,$03 #REGde=#N$E007 (entity update handler address).
  $E16A,$04 Write #REGde to *#REGhl as a little-endian word.
  $E16E,$03 Write #N$00 to *#REGhl; advance #REGhl.
  $E171,$03 Call #R$D1BF to generate a random byte.
  $E174,$02,b$01 Mask to the low two bits.
  $E176,$03 Write entity type (slot ORed with random bits) to *#REGhl.
@ $E179 label=Spawn_Wave_Enemies_Get_Y
  $E179,$03 Call #R$D1BF to generate a random byte.
  $E17C,$05 Retry if below #N$10 (outside valid Y range).
  $E181,$05 Retry if #N$AB or greater (outside valid Y range).
  $E186,$02 Write random Y coordinate to *#REGhl; advance #REGhl.
@ $E188 label=Spawn_Wave_Enemies_Get_X
  $E188,$03 Call #R$D1BF to generate a random byte.
  $E18B,$05 Retry if below #N$08 (outside valid X range).
  $E190,$05 Retry if #N$F1 or greater (outside valid X range).
  $E195,$01 Write random X coordinate to *#REGhl.
  $E196,$03 Stash #REGhl on the stack; step #REGhl back to the type byte.
  $E199,$04 Set #REGb'=#COLOUR$47 via shadow registers.
  $E19D,$05 Spawn the entity via #R$C950, preserving #REGbc.
  $E1A2,$01 Restore #REGhl (X coordinate position).
  $E1A3,$09 Write trailing record bytes #N$0D, #N$07 and #N$FF.
  $E1AC,$03 Advance #REGhl; loop back to #R$E167 for the next entity.
@ $E1AF label=Spawn_Wave_Enemies_Update_Pointer
  $E1AF,$03 Save the entity list write pointer to *#R$C50D.
  $E1B2,$01 Restore #REGde.
  $E1B3,$02 Restore the source pointer; advance past the count byte.
  $E1B5,$01 Return.

c $E1B6 Handle Horizontal Enemy Entity
@ $E1B6 label=Handle_Horizontal_Enemy_Entity
D $E1B6 Per-frame entity handler for the horizontal-moving wave enemy, written
. into entity records by #R$E290. Checks the wave start delay at #N$C533;
. if still counting, skips forward via #R$E099. Otherwise erases the
. sprite, tests player contact via #R$C6DA (triggering death via #R$D2BC
. if touching), searches the wave enemy list for a collision partner via
. #R$E262, and repositions the entity by applying a directional delta
. from the table at #R$E11A. Spawns the entity at its new position via
. #R$C950 and advances the entity record pointer via #R$E094.
  $E1B6,$07 Skip to #R$E099 if the wave start delay at #N$C533 is still
. active.
  $E1BD,$05 Stash the entity record pointer and erase the sprite via #R$C949.
  $E1C2,$01 Advance past the entity handler field.
  $E1C3,$05 Set the player Y position address into alternate #REGhl.
  $E1C8,$03 Test whether this entity overlaps the player via #R$C6DA.
  $E1CB,$03 Trigger the death sequence via #R$D2BC if the entity touches the
. player.
  $E1CE,$03 Step back three bytes to the entity Y position field.
  $E1D1,$03 Search the wave entity list for another entity at this position
. via #R$E262.
  $E1D4,$03 Begin the death animation via #R$E22A if a collision was found.
N $E1D7 Decide whether to pick a new entity type or keep the existing one:
. if a random value is #N$F0 or higher, randomise a new type in the
. range #N$34-#N$37; otherwise reuse the current entity type.
  $E1D7,$06 Switch to alternate registers and generate a random value; compare
. against #N$F0.
  $E1DD,$03 Keep the existing entity type if the random value is below #N$F0.
@ $E1E0 label=Handle_Horizontal_Enemy_Entity_Retry
  $E1E0,$04 Step back to the entity type byte and generate a new random byte
. via #R$D1BF.
  $E1E4,$02,b$01 Mask to the low 2 bits for the entity type offset.
  $E1E6,$04 Add #N$34 to form the entity type, write it, and advance.
  $E1EA,$03 Jump to #R$E1F0.
  $E1ED,$03 Load the existing entity type and advance past it.
N $E1F0 Apply the directional delta from the table to the entity Y and X
. position. Retry if the new position falls outside the play area.
@ $E1F0 label=Handle_Horizontal_Enemy_Entity_Apply_Delta
  $E1F0,$01 Exchange #REGde and #REGhl to preserve the entity record pointer.
  $E1F1,$02,b$01 Mask the entity type to the low 2 bits for the direction
. index.
  $E1F3,$09 Double the direction index and load the delta table base at
. #R$E11A.
  $E1FC,$01 Exchange #REGde and #REGhl to restore the entity record pointer.
  $E1FD,$07 Apply the Y delta to the current Y coordinate; retry via
. #R$E1E0 if the result is outside #N$10-#N$AA.
  $E204,$07 Apply the X delta to the current X coordinate; retry via
. #R$E1E0 if the result is outside #N$08-#N$EB.
  $E20B,$06 Step the delta pointer forward; apply the second delta to X;
. validate X bounds.
  $E211,$0C Write the validated Y and X coordinates back to the entity record.
  $E21D,$09 Stash the record pointer, set colour #N$44, spawn the entity via
. #R$C950, and restore the pointer.
  $E226,$01 Restore the entity record pointer.
  $E227,$03 Advance to the next entity record via #R$E094.

c $E22A Begin Enemy Death Animation
@ $E22A label=Begin_Enemy_Death_Animation
D $E22A Called when a colliding wave enemy is struck: freezes movement, removes
. the sprite, flashes it white, marks it as dying, and starts the #N$32-frame
. death timer. Decrements the live count for this enemy's class. Called from
. #R$E1B6 and #R$E881.
R $E22A HL Entity record pointer (positioned at the entity type byte)
N $E22A Freeze the enemy and remove it from the screen.
  $E22A,$04 Step back four bytes to the entity handler field.
  $E22E,$06 Freeze the enemy: save the entity pointer and call #R$D9C4 with
. movement state #N$03.
  $E234,$02 Restore the entity pointer into #REGhl and keep a copy on the stack.
  $E236,$03 Erase the enemy sprite from the screen via #R$C949.
  $E239,$01 Restore the entity pointer from the stack.
N $E23A Mark the enemy as dying and flash it white to signal the kill.
@ $E23A label=Begin_Enemy_Death_Animation_Flash
  $E23A,$05 Save the entity type in #REGc, stash both on the stack, and mark
. the enemy as dying (#N$0F).
  $E23F,$04 Set the draw colour to #COLOUR$47 in #REGb'.
  $E243,$03 Flash the enemy white on screen via #R$D637.
N $E246 Restore context, reduce the live count, and start the death timer.
  $E246,$02 Restore the entity pointer and entity type from the stack.
  $E248,$08 Shift the entity type right four bits to get the enemy class index.
  $E250,$09 Reduce the live enemy count for this class in the table at #R$C427.
  $E259,$03 Step back to the animation timer byte and set it to #N$32 frames.
  $E25C,$05 Step the alternate entity list pointer back three bytes.
  $E261,$01 Return.

c $E262 Find Colliding Wave Enemy
@ $E262 label=Find_Colliding_Wave_Enemy
D $E262 Walks the wave entity list between the snapshot pointer at #N$C50B and
. the write pointer at #N$C50D. For each entity with a type nibble below
. #N$04, tests bounds overlap via #R$C6DA; returns without carry set if
. an overlapping entity is found with its position left in alternate
. #REGhl. Returns with carry set if the list is exhausted without a
. match. Entities with a type nibble of #N$04 or higher are skipped as
. non-collidable. Called from #R$E1B6 and #R$E881.
@ $E266 label=Find_Colliding_Wave_Enemy_Next
  $E262,$04 Switch to alternate registers and load the entity list snapshot
. pointer from #N$C50B.
  $E266,$09 Compare the snapshot against the write pointer; return with carry
. set (no match) if the list is exhausted.
  $E26F,$05 Advance three bytes past the handler word, read the entity type
. nibble, and mask to the low 4 bits.
  $E274,$02,b$01 Mask the type to the low nibble.
  $E276,$03 Jump to #R$E28A to skip this entity if the type is #N$04 or
. higher (non-collidable).
  $E279,$06 Test whether this entity's bounds overlap the current position
. via #R$C6DA; advance and loop if they do not.
  $E27F,$06 No overlap: step the alternate #REGhl back three bytes and loop.
  $E285,$05 Advance two bytes to the next entity record and loop.
  $E28A,$06 Wide entity: advance three more bytes and loop.

c $E290 Spawn Horizontal Wave Enemies
@ $E290 label=Spawn_Horizontal_Wave_Enemies
D $E290 Entry point called from #R$D24C. Reads the horizontal enemy spawn
. count from *#REGhl and stores it at #N$C42B; if zero, returns
. immediately. Otherwise loops #REGb times, writing a full entity record
. into the entity list: the #R$CF52 handler address, a random entity
. type in the range #N$34-#N$37, a valid random screen position via
. #R$E2C8, and trailing bytes #N$0E, #N$0D, #N$FF. Saves the updated
. entity list pointer to *#R$C509 and writes the #N$D1A4 list terminator.
  $E290,$04 Load the horizontal enemy count from *#REGhl and store it at
. #N$C42B.
  $E294,$03 Return if the spawn count is zero.
  $E297,$02 Set the spawn loop counter in #REGb and stash the source pointer.
  $E299,$03 Load the entity list write pointer from *#R$C509.
@ $E29C label=Spawn_Horizontal_Wave_Enemies_Record
  $E29C,$06 Write the #R$CF52 entity handler as a little-endian word.
  $E2A2,$01 Advance past the handler word.
  $E2A3,$03 Generate a random byte via #R$D1BF.
  $E2A6,$02,b$01 Mask to the low 2 bits for the entity type offset.
  $E2A8,$04 Add #N$34, write the entity type, and advance.
  $E2AC,$05 Stash #REGbc and call #R$E2C8 to place the entity at a valid
. random screen position.
  $E2B1,$03 Restore #REGbc and step back one byte.
  $E2B4,$06 Write trailing record bytes #N$0E, #N$0D, and #N$FF.
  $E2BA,$03 Advance #REGhl and loop back to #R$E29C for the next entity.
  $E2BD,$08 Save the updated entity list pointer to *#R$C509.
  $E2C5,$02 Write the list terminator #N$D1A4 to *#REGhl.
  $E2C7,$01 Return.

c $E2C8 Pick Random Spawn Position
@ $E2C8 label=Pick_Random_Spawn_Position
D $E2C8 Generates a random Y coordinate in the range #N$10-#N$A7 and a random
. X coordinate in the range #N$08-#N$E7, writing both to *#REGhl with
. initial velocities #N$10/#N$10, then tests whether the chosen position
. overlaps the player spawn zone via #R$C6DA; retries the whole selection
. if it does. Called from #R$E290 and #R$E92C.
@ $E2C8 label=Pick_Random_Spawn_Position_Y
  $E2C8,$08 Generate random bytes until a valid Y coordinate (#N$10-#N$A7) is
. found and write it to *#REGhl.
@ $E2D7 label=Pick_Random_Spawn_Position_X
  $E2D7,$08 Generate random bytes until a valid X coordinate (#N$08-#N$E7) is
. found and write it to *#REGhl.
  $E2E5,$06 Write initial Y and X velocities (#N$10 each) to the entity record.
  $E2EB,$08 Step back three bytes and set the player spawn area address in
. alternate #REGhl via #R$D1C7.
  $E2F3,$04 Test whether the position overlaps the player spawn zone via
. #R$C6DA; return if clear.
  $E2F7,$03 Retry the whole position selection from #R$E2C8 if it overlaps.

c $E2FD Clamp Entity Velocity
@ $E2FD label=Clamp_Entity_Velocity
D $E2FD Adds a 16-bit signed delta (#REGde) to a velocity byte in #REGh,
. sign-extending #REGh to a full 16-bit value first, then clamps the
. result to the range #N$FC00-#N$03FF. Returns the clamped result in
. #REGhl. Called from #R$E360 and #R$E6F7 when updating tracked enemy
. velocities.
  $E2FD,$08 Sign-extend #REGh into a 16-bit value and add the delta in
. #REGde.
  $E305,$04 Positive result: check bit 7 and jump if the result is negative.
  $E309,$07 Positive ceiling: return if within range; clamp to #N$03FF
. otherwise.
@ $E315 label=Clamp_Entity_Velocity_Negative
  $E315,$07 Negative result: return if within range; clamp to #N$FC00
. otherwise.

c $E31C Build Entity Spawn Record
@ $E31C label=Build_Entity_Spawn_Record
D $E31C Reads the direction byte from (#REGix+#N$02), indexes the direction
. animation offset table at #R$E7AF by direction × 4, and writes five
. bytes to the entity spawn buffer at #N$C511: the animation type byte
. (#N$28 + direction), the direction-adjusted Y coordinate, the
. direction-adjusted X coordinate, and two further table bytes via
. two LDI instructions. Called from #R$E360.
  $E31C,$0F Index the direction animation table at #R$E7AF and write the
. animation type byte (#N$28 + direction) to the spawn buffer at #N$C511.
  $E32B,$0E Write the direction-adjusted Y and X coordinates to the spawn
. buffer.
  $E339,$07 Copy two further direction table bytes to the spawn buffer via
. LDI×2.
  $E345,$01 Return.

c $E346 Apply Direction Delta
@ $E346 label=Apply_Direction_Delta
D $E346 Reads the direction byte from (#REGde), and uses it as an index into
. the direction animation table at #R$E7AF (direction × 4). Adds the Y
. delta at table[index] to the byte at (#REGde+1) and the X delta at
. table[index+1] to the byte at (#REGde+2), writing the updated
. coordinates back in place. Called from #R$E7EB when building entity
. records.
  $E346,$05 Exchange #REGde and #REGhl and load the direction table base at
. #R$E7AF.
  $E34B,$02,b$01 Mask the direction byte to 3 bits.
  $E34D,$06 Double the index (two left shifts) and form the zero-extended
. byte offset in #REGbc.
  $E353,$0B Apply the Y delta to (#REGde+1) and the X delta to (#REGde+2)
. and write both coordinates back in place.
  $E35E,$02 Exchange #REGde and #REGhl to restore the entity pointer and
. return.

c $E360 Process Tracked Enemy Entity
@ $E360 label=Process_Tracked_Enemy_Entity
D $E360 Per-frame entity handler for IX-indexed tracked wave enemies. If the
. wave start delay is still counting, advances the entity pointer via
. #R$E41C. Otherwise stores the entity record pointer at #R$C50F,
. rebuilds the spawn buffer via #R$E31C, and searches for a collision-
. free slot via #R$CD18. Tests player contact via #R$C6DA and triggers
. death via #R$D2BC if touching. Decrements the animation phase, erases
. the sprite via #R$C949, advances the animation frame within the phase
. mask, then re-enters movement at #R$E3AB. Updates the entity velocity
. with angular rate via #R$D1A8 and #R$E2FD, clamps position to the
. play area, rebuilds the spawn buffer, and draws via #R$C950. When the
. animation phase reaches zero, either removes the entity or promotes
. it to the next phase and spawns a cluster entity with handler #R$E520.
  $E360,$07 Skip to #R$E41C if the wave start delay at #N$C533 is still
. active.
  $E367,$07 Store the entity record pointer at #R$C50F and reload into
. #REGix.
  $E36E,$0A Point #REGhl at the spawn buffer (#N$C512), switch to alternate
. registers, and search for a free entity slot via #R$CD18; jump to
. #R$E4B9 if no free slot is available.
  $E378,$0F Test player contact via #R$C6DA; trigger death via #R$D2BC if
. touching. Reload the entity pointer, decrement the animation phase, and
. erase the entity sprite via #R$C949.
N $E38E Read the animation phase and select the animation frame mask: #N$07
. if the phase is #N$37 or higher, #N$03 otherwise.
  $E38E,$0B Read the phase, select the frame mask, and advance #REGhl.
@ $E39E label=Process_Tracked_Enemy_Entity_Frame
  $E39E,$07 Increment the animation frame within the mask, add the base
. offset #N$28, and write back.
  $E3A5,$03 Jump to #R$E421 if the animation phase has reached zero.
N $E3AB Update the entity velocity: apply the angular rate via #R$D1A8 to
. both Y and X velocity components, clamp each via #R$E2FD, then add
. the velocities to the Y and X position and clamp to the play area.
@ $E3AB label=Process_Tracked_Enemy_Entity_Move
  $E3AB,$06 Load the Y velocity from the entity record and apply the angular
. rate via #R$D1A8.
  $E3B1,$06 Clamp the Y velocity via #R$E2FD and store it back.
  $E3B7,$0C Add the clamped Y velocity to the entity Y position; load and
. apply the angular rate to the X velocity.
@ $E3CF label=Process_Tracked_Enemy_Entity_Clamp_Y
  $E3CF,$07 Clamp the Y position to the floor #N$10 or ceiling #N$A9.
@ $E3D6 label=Process_Tracked_Enemy_Entity_X
  $E3D6,$09 Store the clamped Y position and load the X velocity components.
  $E3DF,$09 Apply the angular rate to the X velocity and clamp via #R$E2FD.
  $E3E8,$0C Add the clamped X velocity to the entity X position.
@ $E400 label=Process_Tracked_Enemy_Entity_Clamp_X
  $E400,$07 Clamp the X position to the floor #N$08 or ceiling #N$E9.
@ $E407 label=Process_Tracked_Enemy_Entity_Draw
  $E407,$09 Store the clamped X position and rebuild the spawn buffer via
. #R$E31C.
  $E410,$09 Set colour #N$42 in #REGb', draw the entity via #R$C950,
. and restore #REGhl.
N $E419 Reload the entity list pointer from #R$C50F and advance it by
. #N$0C bytes.
@ $E419 label=Process_Tracked_Enemy_Entity_Reload
  $E419,$03 Reload #REGhl from #R$C50F.
@ $E41C label=Process_Tracked_Enemy_Entity_Advance
  $E41C,$05 Advance the entity pointer by #N$0C bytes and return.
N $E421 The animation phase has reached zero. If the entity still has
. remaining passes, promote it to the next phase and spawn a cluster
. entity; otherwise remove it from the active set.
@ $E421 label=Process_Tracked_Enemy_Entity_Phase_End
  $E421,$07 If the entity has remaining animation passes, jump to #R$E43C;
. otherwise fall through to remove it.
  $E428,$0B Decrement the active entity count at #N$C42C and the total wave
. enemy count at #R$C41C; write handler #R$E41C and jump to #R$E419.
N $E43C Entity still has passes remaining: increment the animation counters,
. spawn a cluster entity with handler #R$E520 into the entity list, and
. re-enter the movement update loop at #R$E3AB.
@ $E43C label=Process_Tracked_Enemy_Entity_Promote
  $E43C,$0F Set the animation byte to #N$14, decrement the remaining pass
. count, and increment the active count at #N$C42C and #R$C41C.
  $E44B,$08 Load the entity list write pointer from *#R$C509 and write the
. #R$E520 handler.
  $E453,$0E Write the entity type (#N$1C), Y and X coordinates from the
. current entity into the new cluster record.
  $E461,$0A Stash #REGhl, set colour #N$45 in #REGb', draw the
. entity colour slot via #R$D637, and restore #REGhl.
  $E46B,$24 Write the trailing record bytes, advance #REGhl, save the entity
. list pointer, write the #N$D1A4 terminator, and jump to #R$E3AB.

c $E492 Tick Entity Colour Timer
@ $E492 label=Tick_Entity_Colour_Timer
D $E492 Entity handler that drives a per-entity colour timer. Each frame it
. decrements the timer byte; if still non-zero, extracts the animation
. frame index from the low 3 bits and calls #R$CFA4 to refresh the
. entity's attribute colours, then advances the entity pointer by
. #N$0B bytes via #R$E4A2. When the timer reaches zero, falls through
. to #R$E4A7 to erase and retire the entity. Written into entity records
. by #R$E4B9.
  $E492,$10 Decrement the entity timer; if still live, extract the low 3 bits
. as the animation frame index and refresh the entity's attribute colours
. via #R$CFA4.
@ $E4A2 label=Tick_Entity_Colour_Timer_Advance
  $E4A2,$05 Advance the entity pointer by #N$0B bytes and return.

c $E4A7 Retire Expired Entity
@ $E4A7 label=Retire_Expired_Entity
D $E4A7 Erases the entity sprite via #R$D630, writes the #R$E41C advance
. handler to the entity record (retiring the entity from active update
. processing), and returns through #R$E4B4. Reached when a colour timer
. spawned by #R$E4B9 expires.
  $E4A7,$05 Stash #REGhl, advance one byte, and erase the sprite via #R$D630.
  $E4AC,$06 Write the #R$E41C handler to the entity record and advance.
@ $E4B4 label=Retire_Expired_Entity_Advance
  $E4B4,$05 Advance the entity pointer by #N$0E bytes and return.

c $E4B9 Kill Tracked Enemy Entity
@ $E4B9 label=Kill_Tracked_Enemy_Entity
D $E4B9 Kill path reached when no collision-free slot is available for a
. tracked enemy. Steps back six bytes to the entity position fields,
. erases the sprite via #R$C84F, removes the entity record from the
. list via #R$D5B4, and erases the spawn buffer via #R$C949. Decrements
. the active entity count at #N$C42C and the total wave enemy count at
. #R$C41C. Initialises a dying-state colour timer via #R$D9C4, writes
. a replacement #R$E492 entity record at the same position, and scores
. #N$10 BCD points. Refreshes the colour bar via #R$CD34.
  $E4B9,$0A Step back six bytes to the entity position, erase the sprite
. via #R$C84F, and restore #REGhl.
  $E4C3,$04 Remove the entity from the list via #R$D5B4 and erase the spawn
. buffer via #R$C949.
  $E4C7,$07 Decrement the active count at #N$C42C and the wave enemy count
. at #R$C41C.
  $E4CE,$07 Initialise a dying entity state via #R$D9C4 with code #N$02.
  $E4D5,$0C Write handler #R$E492 at #R$C50F and set the entity timer to
. #N$32 frames.
  $E4E1,$09 Copy the entity Y and X position data and set the colour timer
. initial value.
  $E4EA,$16 Point #REGhl back to the Y position, set colour #COLOUR$47 in
. #REGb', and draw via #R$D637.
N $E500 Update the player's BCD score by #N$10 points and propagate any
. carry through the higher-order score digits.
  $E500,$0D Add #N$10 BCD to the units score at #N$C405 and propagate carry
. through two further score digits.
@ $E51A label=Kill_Tracked_Enemy_Score_Bar
  $E51A,$06 Refresh the colour bar via #R$CD34 and advance via #R$E419.

c $E520 Process Cluster Entity
@ $E520 label=Process_Cluster_Entity
D $E520 Per-frame entity handler for the cluster entities spawned when a
. tracked wave enemy promotes. Advances three bytes to a countdown timer,
. decrements it, and redraws the entity via #R$CFA4 while the timer is
. still running. When the timer reaches zero, calls #R$D630 to erase
. the entity sprite. If the animation pass counter (two bytes back) is
. also exhausted, detaches the entity and scores; otherwise increments
. the pass counter, redraws via #R$D637, sets the animation delay to
. #N$04, and jumps to #R$E4A2. On further passes the handler transitions
. to #R$E56D, which searches for player contact via #R$CD18 and triggers
. a kill via #R$E6F7 if found, or else applies directional movement
. toward the player and draws via #R$C856.
  $E520,$07 Advance three bytes to the countdown timer, decrement it, and
. check for expiry.
  $E527,$07 Timer still running: redraw the entity via #R$CFA4 and advance.
@ $E536 label=Process_Cluster_Entity_Expired
  $E536,$06 Timer expired: erase the entity sprite via #R$D630.
  $E53C,$06 Check the pass counter; jump to #R$E553 if the maximum pass
. count (#N$1F) is reached.
  $E542,$0A Increment the pass counter, redraw the entity via #R$D637, and
. write animation delay #N$04.
  $E54C,$04 Jump to #R$E4A2 to advance the entity pointer.
@ $E553 label=Process_Cluster_Entity_Transition
  $E553,$12 Write handler #R$E56D and redraw the entity via #R$D637; set
. the animation byte to #N$0B.
@ $E56D label=Process_Cluster_Entity_Homing
  $E56D,$06 Increment the animation counter and check for overflow; jump to
. #R$E5B8 if the counter wraps.
  $E573,$06 Stash #REGhl, step back one byte, and erase the entity sprite
. via #R$D630.
  $E579,$07 Search for a player-contact slot via #R$CD18, then jump to #R$E6F7
. if player contact is detected.
N $E580 Entity not touching the player: erase the sprite again, score
. #N$02 BCD, and update the colour bar.
  $E580,$0B Step back six bytes, erase the sprite via #R$C84F, and restore
. #REGhl.
  $E58B,$03 Remove the entity from the list via #R$D5B4.
  $E58E,$14 Add #N$02 BCD to the low score digit at #N$C405 and propagate
. carry through two further score digits.
@ $E5A8 label=Process_Cluster_Entity_Score_Bar
  $E5A8,$0E Update the colour bar via #R$CD34, decrement the active count at
. #N$C42D and #R$C41C, restore #REGhl, and mark the entity slot as
. finished.
@ $E5B8 label=Process_Cluster_Entity_Advance
@ $E5B9 label=Process_Cluster_Entity_Next
  $E5B8,$06 Advance four bytes and check the secondary timer byte.
  $E5BE,$0C Decrement the secondary timer; if it reaches zero, erase the
. entity sprite via #R$C84F; then jump to #R$E61C.
@ $E5CE label=Process_Cluster_Entity_Move
  $E5CE,$0D Move to the entity position bytes, switch to alternate registers,
. and set the player Y address in alternate #REGhl; trigger death via
. #R$D2BC if touching.
  $E5DB,$05 Step back four bytes and stash the entity pointer.
  $E5E0,$0E Step back, erase the sprite via #R$C84F, and search for a player
. slot via #R$CD18; jump to #R$E6C4 if player contact.
  $E5EE,$0A Step back six bytes, erase the entity via #R$C84F, score #N$25
. BCD against the six-byte score at #N$C406, and propagate carry.
@ $E605 label=Process_Cluster_Entity_Score_Carry
  $E605,$0B Propagate BCD carry through #REGb higher-order score digits.
@ $E610 label=Process_Cluster_Entity_Bar
  $E610,$0A Refresh the colour bar via #R$CD34, switch to alternate registers,
. and step back #REGde bytes to the entity record start.
@ $E61A label=Process_Cluster_Entity_Seek_Y
@ $E61C label=Process_Cluster_Entity_Seek
  $E61A,$02 Step back two more bytes to the entity handler field.
  $E61C,$0D Load the Y and X position bytes and compute the signed Y offset
. from the player's Y coordinate at #N$C4D4.
  $E629,$18 Compute the signed Y and X distances from the player, halve each
. distance five times to form a velocity nudge, and negate if negative.
@ $E650 label=Process_Cluster_Entity_Seek_X
  $E650,$2A Compute the X nudge from the player's X coordinate at #N$C4D5 in
. the same way.
@ $E67A label=Process_Cluster_Entity_Chase
  $E67A,$07 If both nudge components are zero, replace them with a small
. random drift.
@ $E691 label=Process_Cluster_Entity_Apply
  $E691,$05 Add the Y nudge offset #N$03 to the Y position; advance #REGde
. and #REGhl.
  $E696,$08 Add the X nudge offset #N$02 to the X position and advance.
  $E69E,$08 Write the computed Y and X nudge bytes to the record and stash
. #REGhl.
  $E6A6,$0E Step back six bytes, set colour #COLOUR$47 in #REGb', draw
. via #R$C856, and advance two bytes before returning.

c $E6B4 Retire Cluster Entity
@ $E6B4 label=Retire_Cluster_Entity
D $E6B4 Reached when the cluster entity's secondary animation timer has
. expired and the entity handler address has wrapped. Steps back seven
. bytes, writes the #R$E4B4 handler to the entity record, and advances
. via #R$E4B4. Transitions the entity out of the homing phase into the
. final retire countdown.
  $E6B4,$06 Step back seven bytes and write the #R$E4B4 handler.
  $E6BA,$0A Advance the entity pointer and fall through to #R$E4B4.

c $E6C4 Apply Entity Velocity
@ $E6C4 label=Apply_Entity_Velocity
D $E6C4 Applies a pre-computed velocity nudge (#REGbc) to the Y and X
. position bytes of the entity record, clamping each to the play area
. bounds, and redraws the entity via #R$C856. Called as the contact
. handler from #R$E520 when a cluster entity reaches the player.
  $E6C4,$09 Switch to alternate registers, save the entity position pointer,
. and load the Y and X position bytes.
  $E6CD,$0B Test and apply the Y nudge; clamp Y to #N$10-#N$B3 and write
. back.
@ $E6D8 label=Apply_Entity_Velocity_X
  $E6D8,$0F Test and apply the X nudge; clamp X to #N$08-#N$F3 and write
. back.
@ $E6E7 label=Apply_Entity_Velocity_Draw
  $E6E7,$07 Step back two bytes, set colour #COLOUR$47 in #REGb', and
. draw the entity via #R$C856.
  $E6EE,$08 Restore #REGde, copy to #REGhl, advance two bytes, and return.

c $E6F7 Process Player Tracking Enemy
@ $E6F7 label=Process_Player_Tracking_Enemy
D $E6F7 Per-frame entity handler for the slow player-tracking enemy. Tests
. player contact via #R$C6DA; triggers death via #R$D2BC if touching.
. Computes the signed Y and X distance from the player at #N$C4D4 and
. #N$C4D5, halves it five times to derive a velocity nudge, and negates
. if the enemy is above or to the left of the player. Reads the entity
. facing byte; on a random 1-in-8192 chance sets it to #N$1A (freeze
. state). If the facing is #N$1A, flips both velocity components and
. tests for a 1-in-256 chance to clear the freeze. Applies the computed
. Y and X nudge to the entity position, clamping to the play area, and
. draws the entity via #R$D637.
  $E6F7,$07 Set the player Y address in alternate #REGhl and test player
. contact via #R$C6DA; trigger death via #R$D2BC if touching.
  $E6FE,$08 Step back three bytes to the entity Y position and load the
. player Y coordinate at #N$C4D4.
  $E709,$10 Compute the signed Y nudge: subtract the entity Y from the
. player Y, halve five times, and negate if the entity is above the
. player.
@ $E719 label=Process_Player_Tracking_Enemy_Nudge_Y
  $E719,$11 Scale the Y nudge and restore its sign.
@ $E72A label=Process_Player_Tracking_Enemy_Nudge_X
  $E72A,$28 Compute the signed X nudge from the player X coordinate at
. #N$C4D5 in the same way.
@ $E752 label=Process_Player_Tracking_Enemy_Face
  $E752,$09 Store the scaled Y nudge in #REGb and X nudge in #REGc; step
. back to the entity facing byte.
  $E75B,$18 Read the facing byte; if #N$1A, jump to #R$E773; otherwise
. test a 1-in-8192 random chance (#R$D1BF twice, masked to #N$1F and
. #N$3F) to set the facing to #N$1A (freeze).
@ $E773 label=Process_Player_Tracking_Enemy_Freeze
  $E773,$12 Facing is #N$1A (frozen): negate both velocity components;
. test a 1-in-256 chance to promote the facing to #N$1F (thaw).
@ $E785 label=Process_Player_Tracking_Enemy_Move
  $E785,$0E Apply the Y nudge to the entity Y position; clamp to #N$10-#N$AD
. and write back.
@ $E793 label=Process_Player_Tracking_Enemy_Move_X
  $E793,$0E Apply the X nudge to the entity X position; clamp to #N$08-#N$EF
. and write back.
@ $E7A1 label=Process_Player_Tracking_Enemy_Draw
  $E7A1,$0B Stash #REGhl, step back two bytes, set colour #N$45 in alternate
. #REGb, draw the entity via #R$D637, restore #REGhl, and advance via
. #R$E5B9.

b $E7AF Direction Animation Offset Table
@ $E7AF label=Direction_Animation_Offset_Table
D $E7AF Eight 4-byte entries (one per direction #N$00-#N$07) used by
. #R$E31C and #R$E346. Each entry holds a Y delta, an X delta, and two
. further bytes that are copied verbatim into the entity spawn buffer.
. Indexed as table + (direction × 4).
B $E7AF,$20

c $E7CF Spawn Tracked Enemy Entities
@ $E7CF label=Spawn_Tracked_Enemy_Entities
D $E7CF Initialises the tracked-enemy active count at #N$C42D to zero, copies
. the per-wave count byte into #N$C42C and adds it to the total wave
. enemy count at #R$C41C, then stashes the wave data pointer. If the
. count is zero, jumps to #R$E855; otherwise loops #REGb times: writes
. a 14-byte entity record (handler #R$E360, entity type #N$B0, random
. type variant, random screen position via #R$E2C8, three initial bytes
. from the wave data for velocity seeds, and #N$FF as the terminator)
. into the entity list via *#R$C509, spawning each entity via #R$C950.
. Closes the entity list with the #N$D1A4 terminator.
  $E7CF,$09 Clear #N$C42D, copy the spawn count into #N$C42C, and accumulate
. it into the wave enemy count at #R$C41C.
  $E7D8,$09 Stash the wave data pointer, load the entity list write pointer,
. and jump to #R$E855 if the count is zero.
@ $E7EB label=Spawn_Tracked_Enemy_Entities_Record
  $E7EB,$0B Write the #R$E360 handler and entity type #N$B0 to the entity
. list record.
  $E7F6,$03 Generate a random entity type variant via #R$D1BF.
  $E7F9,$07 Mask to 2 bits for the type variant and add #N$28.
  $E800,$02 Write the entity type variant and advance.
  $E802,$0C Point #REGhl at the spawn buffer, write the type variant, and
. call #R$E2C8 to generate a valid random screen position.
  $E80E,$0F Copy three bytes from the wave data at #N$C53B using LDD×4 and
. apply the direction delta via #R$E346.
  $E81D,$07 Set colour #N$42 in #REGb' and spawn the entity via
. #R$C950.
  $E824,$16 Write three velocity seed bytes, initial deltas, and the #N$FF
. record terminator; loop back to #R$E7EB for the next entity.
@ $E855 label=Spawn_Tracked_Enemy_Entities_Terminate
  $E855,$08 Save the entity list pointer to *#R$C509 and write the #N$D1A4
. terminator.
  $E85D,$02 Write #N$FF and advance #REGhl.
  $E85F,$03 Restore the wave data pointer and return.

c $E863 Evaluate and Spawn Tracked Enemies
@ $E863 label=Evaluate_And_Spawn_Tracked_Enemies
D $E863 Entry point called from #R$D24C. Reads the tracked enemy active count
. at #N$C42C; if non-zero, jumps immediately to the spawn step at
. #R$E879. Otherwise checks #N$C42D; if zero, also jumps to #R$E879.
. If #N$C42D is non-zero, halves it twice: if the result is still
. non-zero, jumps to #R$E879; otherwise increments #REGa to #N$01 and
. falls through to store the spawn count and call #R$E7CF.
  $E863,$0A If the tracked enemy active count at #N$C42C is non-zero, skip
. to #R$E879.
  $E86D,$04 If the set count at #N$C42D is also zero, skip to #R$E879.
  $E871,$07 Halve #N$C42D twice; if the result is still non-zero, skip to
. #R$E879.
  $E878,$01 Set spawn count to 1.
@ $E879 label=Evaluate_And_Spawn_Tracked_Enemies_Go
  $E879,$03 Store the spawn count at #N$C42C.
  $E87C,$04 Call #R$E7CF to spawn the tracked enemy wave and advance.

c $E881 Process Wall Bouncing Enemy
@ $E881 label=Process_Wall_Bouncing_Enemy
D $E881 Per-frame handler for the wall-bouncing enemy. If the wave start
. delay is still counting down, advances to the next entity record without
. processing. Otherwise checks for player contact via #R$CD18 and triggers
. player death via #R$D2BC if the bouncer is touching. If the bouncer is
. already dying, skips to the draw step. Searches the wave enemy list for
. a collision via #R$E262; if none is found, defers to #R$EA17. On a hit,
. decrements a countdown timer; when it expires the bouncer erases itself,
. nudges one step toward the player, picks a new heading, and redraws.
R $E881 HL Entity record pointer
N $E881 If the wave is still warming up, skip ahead without processing.
  $E881,$07 If the wave start delay at #R$C533 is non-zero, skip to #R$E90F.
N $E888 Check whether the player is touching the bouncer and kill them if so.
  $E888,$02 Advance to the velocity pair.
  $E88A,$01 Switch to alternate registers.
  $E88B,$03 Search for a contact slot via #R$CD18.
  $E88E,$03 Jump to #R$E974 if player contact is confirmed.
  $E891,$06 Load the player position from #R$C4D4 and test overlap via #R$C6DA.
  $E897,$03 Kill the player via #R$D2BC if the overlap test confirmed contact.
  $E89A,$04 Switch back and step three bytes toward the entity record start.
N $E89E If the bouncer is already dying, skip directly to the draw step.
  $E89E,$07 If the bouncer is already dying (bit 0 of active flag), skip to #R$E90F.
N $E8A5 Search the wave enemy list for an enemy the bouncer has hit.
  $E8A5,$05 Step ahead and search the wave enemy list for a collision via #R$E262.
  $E8AA,$03 Jump to #R$EA17 if no wave enemy collision was detected.
  $E8AD,$02 Switch to alternate registers and step back to the bounce timer.
N $E8AF Tick down the bounce countdown; erase and redirect when it expires.
  $E8AF,$05 Step to the bounce timer and subtract #N$04.
  $E8B4,$02 If the countdown has not reached zero, skip to #R$E90F.
  $E8B6,$02 Reset the bounce countdown to #N$0C.
  $E8B8,$07 Erase the bouncer sprite via #R$C949, preserving the entity pointer.
N $E8BF Step the bouncer one pixel toward the player and pick a new heading.
  $E8BF,$04 Measure the signed Y distance to the player at #R$C4D4.
  $E8C3,$08 Set the Y step: #N$01 (player below), #N$FF (player above), or #N$00.
@ $E8CB label=Process_Wall_Bouncing_Enemy_Step_Y
  $E8CB,$04 Store the Y step in #REGb, apply it to the Y position, and advance.
  $E8CF,$04 Measure the signed X distance to the player at #R$C4D5.
  $E8D3,$08 Set the X step: #N$01 (player right), #N$FF (player left), or #N$00.
@ $E8DB label=Process_Wall_Bouncing_Enemy_Step_X
  $E8DB,$08 Store the X step in #REGc, apply it to the X position, and pack both
. step signs into a 4-bit direction code.
N $E8E3 Apply the new heading: look up the direction colour and redraw.
  $E8E3,$08 Pack the Y and X step signs into a 4-bit direction code.
  $E8EB,$08 Look up the heading colour from the direction table at #R$EAF7.
  $E8F3,$02 Write the heading colour to the entity record.
  $E8F5,$0D Look up the animation frame colour from the cycle table at #R$EA0F.
  $E902,$07 Restore the entity pointer, set the frame colour in #REGb', and
. respawn the bouncer via #R$C950.
  $E909,$01 Restore the entity pointer from the stack.
  $E90A,$04 Advance four bytes to the next entity record.
  $E90E,$01 Return.
@ $E90F label=Process_Wall_Bouncing_Enemy_Advance
N $E90F Bouncer skipped: look up the animation colour and redraw without moving.
  $E90F,$0A Advance one byte, stash the pointer, and read the frame index from #R$C4E5.
  $E919,$0A Look up the animation colour from #R$EA0F and set it in #REGb'.
  $E923,$03 Draw the bouncer in its current position via #R$D004.
  $E926,$01 Restore the entity pointer from the stack.
  $E927,$04 Step six bytes to the next entity record.
  $E92B,$01 Return.

c $E92C Spawn Wall Bouncing Enemies
@ $E92C label=Spawn_Wall_Bouncing_Enemies
D $E92C Called from #R$D24C. Reads the wall-bouncing enemy spawn count from
. *#REGhl and stores it at #R$C42F. Returns immediately if the count is
. zero. Otherwise adds the count to the wave enemy total at #R$C41C and
. spawns #REGb bouncers, writing each entity record (handler #R$E881,
. entity type #N$04, random screen position via #R$E2C8, and state bytes
. #N$0F and #N$0A) into the entity list at *#R$C509. Closes the list
. with #R$D1A4 and restores the wave data pointer.
R $E92C HL Wave data pointer
  $E92C,$04 Read the spawn count from the wave data and store it at #R$C42F.
  $E930,$01 Advance past the spawn count byte.
  $E931,$02 Return if no bouncers need spawning.
N $E933 Update the wave enemy total and load the entity list write pointer.
  $E933,$08 Add the spawn count to the wave enemy total at #R$C41C.
  $E93B,$01 Stash the wave data pointer on the stack.
  $E93C,$03 Load the entity list write pointer from #R$C509.
@ $E93F label=Spawn_Wall_Bouncing_Enemies_Record
N $E93F Write the entity record and spawn the bouncer at a random position.
  $E93F,$06 Write the entity handler address #R$E881 into the first two bytes.
  $E945,$07 Write entity type #N$04 and initial state byte #N$26 to the record.
  $E94C,$01 Stash the spawn loop counter on the stack.
  $E94D,$03 Generate a random spawn position via #R$E2C8.
  $E950,$01 Step back to the Y position field.
  $E951,$01 Stash #REGhl on the stack.
  $E952,$07 Step back three bytes and set spawn colour #COLOUR$41 in #REGb'.
  $E959,$03 Spawn the bouncer in the generated position via #R$C950.
  $E95C,$01 Restore the position pointer from the stack.
  $E95D,$03 Write the active state byte #N$0F and advance.
  $E960,$03 Write the bounce counter #N$0A and advance.
  $E963,$03 Write the end-of-record marker #N$FF and advance.
  $E966,$01 Restore the spawn loop counter from the stack.
  $E967,$02 Loop back to #R$E93F until all bouncers are spawned.
N $E969 Save the entity list pointer and write the list terminator.
  $E969,$03 Save the updated entity list write pointer to #R$C509.
  $E96C,$06 Write the list terminator address #R$D1A4 to *#REGhl.
  $E972,$01 Restore the wave data pointer from the stack.
  $E973,$01 Return.

c $E974 Kill Wall Bouncing Enemy
@ $E974 label=Kill_Wall_Bouncing_Enemy
D $E974 Reached when a wall-bouncing enemy makes contact with the player.
. Saves the entity position in #R$C4DA, erases the sprite via #R$C84F,
. and removes the entity from the list via #R$D5B1. Decrements the wave
. enemy total at #R$C41C and the bouncing enemy count at #R$C42F. Triggers
. the border colour effect via #R$D9C4 and awards #N$05 BCD points.
. Refreshes the colour bar, double-erases the sprite via #R$C949 and
. #R$DAAF, writes the dying handler #R$E9CC into the record, and returns.
N $E974 Save the entity position and remove the bouncer from the enemy list.
  $E974,$05 Step back six bytes to the entity position.
  $E979,$03 Save the entity position in #R$C4DA.
  $E97C,$03 Call #R$C84F to erase the bouncer sprite.
  $E97F,$03 Call #R$D5B1 to remove the bouncer from the entity list.
N $E982 Decrement the wave enemy and bouncing enemy counts.
  $E982,$04 Decrement the wave enemy total at #R$C41C.
  $E986,$04 Decrement the bouncing enemy count at #R$C42F.
N $E98A Trigger the border colour flash and award five BCD points for the kill.
  $E98A,$05 Call #R$D9C4 to trigger the border colour effect.
  $E98F,$0A Add #N$05 BCD points to the units score digit at #R$C403(#N$C405).
  $E999,$0E Propagate the BCD carry through the tens and hundreds score digits.
@ $E9A7 label=Kill_Wall_Bouncing_Enemy_Spawn
N $E9A7 Refresh the colour bar and set up the dying animation handler.
  $E9A7,$03 Call #R$CD34 to refresh the colour bar.
  $E9AA,$02 Load #INK$02 into #REGb.
  $E9AC,$01 Switch to alternate registers.
  $E9AD,$01 Step back to the entity position field.
  $E9AE,$03 Save the position pointer at #R$C50F.
  $E9B1,$03 Call #R$C949 to erase the sprite.
  $E9B4,$03 Reload the position pointer from #R$C50F.
  $E9B7,$03 Call #R$DAAF to XOR-erase the sprite.
  $E9BA,$03 Reload the position pointer from #R$C50F.
N $E9BD Install the dying animation handler and advance past the entity record.
  $E9BD,$03 Step back and set the death timer to #N$02.
  $E9C0,$07 Write the dying handler address #R$E9CC into the entity record.
  $E9C7,$04 Step nine bytes forward to the next entity slot.
  $E9CB,$01 Return.

c $E9CC Animate Wall Bouncing Enemy Death
@ $E9CC label=Animate_Wall_Bouncing_Enemy_Death
D $E9CC Per-frame death handler for a wall-bouncing enemy, written by
. #R$E974. Each frame, XOR-draws the entity using the stored animation
. colour, then increments the death animation counter. When it reaches
. #N$0F, writes #R$E02C as the retire handler and jumps to it. Otherwise
. loads the counter into #REGb', reads the entity Y position, selects a
. scroll offset (#N$F8 within the play area, #N$F0 near the ceiling),
. updates the Y position, XOR-erases the entity, and jumps to #R$E094.
R $E9CC HL Entity record pointer
N $E9CC XOR-draw the entity with the stored animation colour.
  $E9CC,$04 Load the animation colour from the entity record into #REGb'.
  $E9D0,$01 Stash the entity pointer on the stack.
  $E9D1,$04 Step to the draw position and call #R$DAAF to XOR-draw the entity.
  $E9D5,$01 Restore the entity pointer from the stack.
N $E9D6 Increment the death counter and retire when it reaches #N$0F.
  $E9D6,$06 Increment the counter and jump to #R$EA03 when it reaches #N$0F.
N $E9DC Load the new frame colour and read the entity Y position.
  $E9DC,$06 Set the frame colour in #REGb' and read the entity Y position.
N $E9E2 Select the scroll offset based on the Y position.
  $E9E2,$04 Jump to #R$E9EE if the entity is within the play area.
  $E9E6,$06 Load zero scroll offset and jump to #R$EA01 if the
. ceiling boundary is exceeded.
  $E9EC,$02 Jump to #R$E9F6 to apply the scroll offset.
@ $E9EE label=Animate_Wall_Bouncing_Enemy_Death_Scroll
N $E9EE Choose the scroll speed based on distance from the ceiling.
  $E9EE,$08 Select scroll offset #N$F8 if within bounds, or #N$F0 if near
. the ceiling.
@ $E9F6 label=Animate_Wall_Bouncing_Enemy_Death_Apply
N $E9F6 Apply the scroll offset, XOR-erase the entity, and advance.
  $E9F6,$07 Apply the scroll offset to the Y position and call #R$DAAF to
. XOR-erase the entity.
  $E9FD,$01 Restore the entity pointer from the stack.
  $E9FE,$03 Jump to #R$E094 to advance the entity pointer.
@ $EA01 label=Animate_Wall_Bouncing_Enemy_Death_Ceil
  $EA01,$02 Step back to the entity handler field.
@ $EA03 label=Animate_Wall_Bouncing_Enemy_Death_End
N $EA03 Write the retire handler and jump to it.
  $EA03,$09 Write the retire handler address #R$E02C into the entity record.
  $EA0C,$03 Jump to #R$E02C.

b $EA0F Enemy Colour Cycle Table
@ $EA0F label=Enemy_Colour_Cycle_Table
D $EA0F Eight attribute bytes used by #R$E881 and #R$E9CC to set the entity
. display colour on each animation frame. Indexed by the low 3 bits of
. the colour cycle counter at #N$C4E5.
B $EA0F,$01 #COLOUR(#PEEK(#PC)).
L $EA0F,$01,$08

c $EA17 Handle Enemy Collision Chain
@ $EA17 label=Handle_Enemy_Collision_Chain
D $EA17 Reached from #R$E881 when the bouncer finds no collision partner.
. Flags the entity as active, reads the entity type and state, decrements
. the slot count at #R$C427, and installs the retire handler #R$E02C.
. Then appends a replacement entity record (handler #R$EA6E) to the entity
. list at *#R$C509, writes the list terminator #R$D1A4, and jumps to
. #R$E90F to redraw without moving.
R $EA17 HL Entity record pointer
N $EA17 Flag the bouncer as active and save the entity record pointer.
  $EA17,$01 Switch to alternate registers.
  $EA18,$05 Step back five bytes to the entity active flag.
  $EA1D,$02 Set the entity active flag to #N$01.
  $EA1F,$01 Stash the entity record pointer on the stack.
  $EA20,$01 Switch to main registers.
N $EA21 Read the entity state and extract the type index.
  $EA21,$05 Step back through the record and read the entity type into
. #REGb and the count into #REGc.
  $EA26,$05 Read the entity state byte into #REGa, write the countdown
. timer #N$0F, and stash the record pointer.
  $EA2B,$0B Extract the entity type index (upper nibble of #REGa) into #REGde.
N $EA36 Decrement the slot count and install the retire handler.
  $EA36,$05 Look up the slot count at #R$C427 and decrement it.
  $EA3B,$01 Restore the entity record pointer from the stack.
  $EA3C,$02 Step back to the retire handler field.
  $EA3E,$06 Write the retire handler #R$E02C into the entity record.
N $EA44 Open a new entity record for the replacement handler.
  $EA44,$0D Load the entity list write pointer from #R$C509 and write the
. #R$EA6E handler and state byte #N$23.
N $EA51 Write the entity fields and save the list pointer.
  $EA51,$08 Write the entity state, count, type, and count to the
. replacement record.
  $EA59,$01 Restore the entity record pointer from the stack.
  $EA5A,$07 Write the entity record pointer into the replacement record
. and save the updated list pointer to #R$C509.
N $EA61 Close the entity list and advance to the draw step.
  $EA61,$09 Write the list terminator #R$D1A4 and end marker #N$FF.
  $EA6A,$04 Switch to alternate registers and jump to #R$E90F.

c $EA6E Process Replacement Enemy Entity
@ $EA6E label=Process_Replacement_Enemy_Entity
D $EA6E Per-frame handler for the replacement entity spawned by #R$EA17.
. Jumps to #R$EB07 if the countdown has already expired. Otherwise
. locates the associated entity record pointer and jumps to #R$EAD0 to
. retire if the associated record is in settled state (#N$02). Decrements
. the countdown and calls #R$C950 to erase. If the countdown is still
. non-zero, applies a random X nudge (±7) and spawns via #R$C950. If the
. countdown reaches zero, copies entity data, resets state, and spawns
. via #R$EAA3. When settled, installs the retire handler #R$E003.
R $EA6E HL Entity record pointer
N $EA6E Test the countdown and locate the associated entity record.
  $EA6E,$05 Jump to #R$EB07 if the entity countdown has already expired.
  $EA73,$09 Save the entity pointer in #REGbc and load the associated
. entity record pointer from offset #N$0005.
  $EA7C,$07 Read the associated entity state, restore #REGhl, and jump
. to #R$EAD0 if settled (#N$02).
  $EA83,$01 Decrement the entity countdown.
N $EA84 Erase the entity with colour #COLOUR$42.
  $EA84,$01 Stash the entity pointer on the stack.
  $EA85,$01 Advance to the entity position.
  $EA86,$04 Load #COLOUR$42 into #REGb'.
  $EA8A,$03 Call #R$C950 to erase the entity.
  $EA8D,$01 Restore the entity pointer from the stack.
N $EA8E Test the countdown and branch.
  $EA8E,$04 Jump to #R$EAB2 if the countdown has reached zero.
  $EA92,$02 Advance two bytes into the entity record.
N $EA94 Apply a random X nudge to the entity position.
  $EA94,$02 Advance two more bytes to the X position field.
  $EA96,$03 Call #R$D1BF to generate a random byte.
  $EA99,$02,b$01 Mask to the lower four bits.
  $EA9B,$02 Subtract #N$07 to produce a nudge in the range #N$F9–#N$07.
  $EA9D,$04 Apply the nudge to the entity X position and step back two
. bytes.
  $EAA1,$01 Step back one more byte to the entity record position field.
  $EAA2,$01 Stash the entity record pointer on the stack.
@ $EAA3 label=Process_Replacement_Enemy_Entity_Spawn
N $EAA3 Generate a random spawn colour and spawn the entity.
  $EAA3,$01 Switch to alternate registers.
  $EAA4,$03 Call #R$D1BF to generate a random colour byte.
  $EAA7,$02,b$01 Mask to bits 3–5 to select the spawn colour.
  $EAA9,$02 Load the colour into #REGb and switch to main registers.
  $EAAB,$03 Call #R$C950 to spawn the entity.
  $EAAE,$01 Restore the entity record pointer from the stack.
  $EAAF,$03 Jump to #R$E094 to advance the entity pointer.
@ $EAB2 label=Process_Replacement_Enemy_Entity_Settle
N $EAB2 Copy entity data and reset the settle state.
  $EAB2,$08 Step two bytes ahead, copy #REGhl to #REGde, step two more,
. and copy one byte to the destination.
  $EABA,$05 Read the countdown into #REGc, reset it to #N$0A, advance,
. and read the type byte into #REGb.
  $EABF,$09 Reset the type field to #N$FF, write state value #N$0F to
. *#REGde and #N$0C to *#REGbc.
  $EAC8,$08 Step #REGde back three bytes, stash #REGde, exchange
. #REGde and #REGhl, and jump to #R$EAA3.
@ $EAD0 label=Process_Replacement_Enemy_Entity_Retire
N $EAD0 Write the retire handler, erase the sprite, draw, and return.
  $EAD0,$0C Write the retire handler #R$E003 and state byte #N$32 into
. the entity record.
  $EADC,$01 Stash the entity pointer on the stack.
  $EADD,$03 Call #R$C949 to erase the entity sprite.
  $EAE0,$01 Restore the entity pointer from the stack.
  $EAE1,$02 Write the state timer #N$0F.
  $EAE3,$01 Stash the entity pointer on the stack.
  $EAE4,$04 Load #COLOUR$47 into #REGb'.
  $EAE8,$03 Call #R$D637 to draw the entity.
  $EAEB,$01 Restore the entity pointer from the stack.
  $EAEC,$03 Advance one byte and copy #REGhl to #REGde.
  $EAEF,$04 Step four bytes to the end-marker field.
  $EAF3,$02 Write the end marker #N$FF.
  $EAF5,$01 Advance to the next entity slot.
  $EAF6,$01 Return.

b $EAF7 Enemy Direction Code Table
@ $EAF7 label=Enemy_Direction_Code_Table
D $EAF7 Sixteen direction-code bytes used by #R$E881 to map a packed
. 4-bit direction index (Y-sign × 4 | X-sign) to a colour attribute byte
. written into the wall-bouncing enemy record. Indexed as table + BC
. where BC = (Y_direction & #N$03) | (X_direction << 2).
B $EAF7,$10

c $EB07 Process Final Phase Enemy Entity
@ $EB07 label=Process_Final_Phase_Enemy_Entity
D $EB07 Per-frame handler for the final phase of a wall-bouncing enemy,
. reached from #R$EA6E when the replacement entity countdown expires.
. Spawns the entity with colour #INK$07, calls #R$CD18 to search for a
. player-contact slot, and jumps to #R$EB7B if none is found. Calls
. #R$C6DA to test player contact and jumps to #R$D2BC to kill the
. player if touching. Steps back to the direction field and generates a
. random value; keeps the current direction if below #N$F0, otherwise
. picks a new direction, wraps it within #N$33, and writes it back.
. Looks up Y and X deltas from #R$EBB4 (direction & #N$03 × 2),
. validates the new position within the play area, and spawns the
. entity. If no contact slot is found, erases the sprite, removes the
. entity from the list, awards BCD score, and writes the retire handler.
R $EB07 HL Entity record pointer
N $EB07 Advance past the countdown byte and spawn with white colour.
  $EB07,$01 Advance past the countdown field.
  $EB08,$01 Stash the entity pointer on the stack.
  $EB09,$04 Load #INK$07 into #REGb'.
  $EB0D,$03 Call #R$C950 to spawn the entity.
  $EB10,$01 Restore the entity pointer from the stack.
  $EB11,$02 Advance one byte and switch to alternate registers.
N $EB13 Search for a player-contact slot and test overlap.
  $EB13,$06 Call #R$CD18 to search for a player-contact slot and jump to
. #R$EB7B if none is found.
  $EB19,$06 Load the player position at #R$C4D4 and call #R$C6DA to test
. overlap.
  $EB1F,$03 Jump to #R$D2BC to kill the player if contact is confirmed.
  $EB22,$01 Switch to main registers.
N $EB23 Step back to the direction field and pick or keep a direction.
  $EB23,$03 Step back three bytes to the direction field.
  $EB26,$03 Call #R$D1BF to generate a random value.
  $EB29,$05 Keep the current direction if the value is below #N$F0.
@ $EB2E label=Process_Final_Phase_Enemy_Entity_Retry
N $EB2E Increment and mask the direction byte.
  $EB2E,$03 Step back to the direction field, load it, and increment it.
  $EB31,$02,b$01 Mask the direction within #N$33.
  $EB33,$05 Write the new direction, advance, and jump to #R$EB3B.
@ $EB38 label=Process_Final_Phase_Enemy_Entity_Keep
  $EB38,$03 Step back to the direction field, load it, and advance.
@ $EB3B label=Process_Final_Phase_Enemy_Entity_Apply
N $EB3B Look up movement deltas and validate the new position.
  $EB3B,$01 Exchange #REGde and #REGhl.
  $EB3C,$02,b$01 Mask the direction to the low 2 bits.
  $EB3E,$09 Double the index, load the movement table base at #R$EBB4,
. and step to the entry.
  $EB47,$0D Add the Y delta to the entity Y position and jump to #R$EB2E
. if outside #N$10–#N$AA.
  $EB54,$01 Save the validated Y position in #REGc.
  $EB55,$0E Advance to the X position, apply the X delta, and jump to
. #R$EB63 if outside the play area.
@ $EB63 label=Process_Final_Phase_Enemy_Entity_X_Retry
  $EB63,$04 Step back one byte and jump to #R$EB2E to retry.
@ $EB67 label=Process_Final_Phase_Enemy_Entity_Write
N $EB67 Write the validated coordinates and spawn with a random colour.
  $EB67,$04 Write the validated X and Y coordinates to the entity record.
  $EB6B,$01 Stash the entity pointer on the stack.
  $EB6C,$01 Switch to alternate registers.
  $EB6D,$03 Call #R$D1BF to generate a random colour byte.
  $EB70,$02,b$01 Mask to bits 3–5 to select the spawn colour.
  $EB72,$02 Load the colour into #REGb and switch to main registers.
  $EB74,$03 Call #R$C950 to spawn the entity.
  $EB77,$01 Restore the entity pointer from the stack.
  $EB78,$03 Jump to #R$E094 to advance the entity pointer.
@ $EB7B label=Process_Final_Phase_Enemy_Entity_Kill
N $EB7B Erase the entity, remove it from the list, and award the score.
  $EB7B,$08 Step back six bytes to the entity record and save the address
. in #R$C4DA.
  $EB83,$03 Call #R$C84F to erase the entity sprite.
  $EB86,$03 Call #R$D5B1 to remove the entity from the list.
  $EB89,$05 Load code #N$00 and call #R$D9C4 to initialise the entity
. state.
N $EB8E Increment the BCD score and propagate carry to higher digits.
  $EB8E,$0A Load #R$C405, add #N$01 BCD, write it back, and jump to
. #R$EBA6 if no carry.
  $EB98,$08 Carry to the tens digit: load, add #N$01 BCD, write back, and
. jump to #R$EBA6 if no carry.
  $EBA0,$06 Carry to the hundreds digit: load, add #N$01 BCD, and write
. back.
@ $EBA6 label=Process_Final_Phase_Enemy_Entity_Score_Bar
N $EBA6 Refresh the colour bar and write the retire handler.
  $EBA6,$03 Call #R$CD34 to refresh the colour bar.
  $EBA9,$01 Switch to main registers.
  $EBAA,$03 Step back three bytes to the entity handler field.
  $EBAD,$06 Write the retire handler #R$E02C into the entity record.
  $EBB3,$01 Return.

b $EBB4 Enemy Movement Delta Table
@ $EBB4 label=Enemy_Movement_Delta_Table
D $EBB4 Four 2-byte entries (Y delta, X delta) used by #R$EB07 to move the
. final-phase enemy one step in one of four diagonal directions. Indexed
. as table + (direction & #N$03) × 2. The four entries encode movement
. by 3 pixels: up-left (#N$FD, #N$00), right (#N$00, #N$03), down
. (#N$03, #N$00), and left (#N$00, #N$FD).
B $EBB4,$08,$02

c $EBBC Game Entry Point
@ $EBBC label=GameEntryPoint
  $EBBC,$03 #REGsp=#N$5FFE.
  $EBBF,$01 Disable interrupts.
  $EBC0,$05 Write #N$08 to *#R$8FF2.
  $EBC5,$03 Jump to #R$F4EC.

c $EBC8 Display High Score Entry Screen
@ $EBC8 label=Display_High_Score_Entry_Screen
D $EBC8 Initialises the high score entry screen: clears the display, prints the
. option header from #R$EE66, and renders the current score entries with
. their cursor markers. Runs a #N$4B-frame input loop allowing keyboard and
. joystick adjustment of the three score entry fields via #R$EDAA and
. #R$EDDD. After name entry, redraws the final score table and cycles the
. display for #N$32 frames before jumping to the attract mode at #R$F4EC.
  $EBC8,$04 Clear the display with attribute #INK$00 via #R$ECA4.
  $EBCC,$03 Initialise the scrolling display via #R$F09D.
  $EBCF,$03 Advance the colour cycle via #R$F0EE.
  $EBD2,$06 Call #R$9006 using #R$EE66.
  $EBD8,$05 Write #N$06 to *#R$C500.
  $EBDD,$05 Write #N$46 to *#R$C501.
  $EBE2,$05 Write #N$04 to *#R$C502.
  $EBE7,$03 Load the first score entry cursor from #R$C4FD.
  $EBEA,$02 Set the column position to #N$19.
  $EBEC,$03 Render the first score entry character via #R$ECCA.
  $EBEF,$03 Load the second score entry cursor from #R$C4FE.
  $EBF2,$03 Highlight the second score entry character via #R$ECD5.
  $EBF5,$03 Load the third score entry cursor from #R$C4FF.
  $EBF8,$02 Set the column position to #N$49.
  $EBFA,$03 Render the third score entry character via #R$ECCA.
  $EBFD,$01 Clear #REGa.
  $EBFE,$02 Set the column position to #N$99.
  $EC00,$03 Clear the bottom score entry position via #R$ECCA.
  $EC03,$01 Switch to the alternate registers.
  $EC04,$02 Set the name entry frame counter to #N$4B in #REGb'.
@ $EC06 label=High_Score_Entry_Loop
N $EC06 Per-frame name entry loop: services controls and handles character
. selection for all three score entry fields each frame.
  $EC06,$01 Switch back to the main registers for this frame.
  $EC07,$02 Set the frame delay count to #N$64.
  $EC09,$03 Run the per-frame timing delay via #R$ECDE.
  $EC0C,$03 Check for the BREAK key combination via #R$ECE6.
  $EC0F,$03 Check for the S key via #R$ECFB.
  $EC12,$03 Check for tape save/load keys (J/L) via #R$ED10.
  $EC15,$03 Read the joystick input via #R$ED7C.
  $EC18,$03 Point #REGde to the score entry columns at #R$C500.
  $EC1B,$04 Point #REGix to the score entry parameters at #R$C503.
  $EC1F,$03 Update the score display via #R$ED93.
  $EC22,$03 Advance the colour cycle via #R$F0EE.
  $EC25,$03 #HTML(Call <a href="https://skoolkit.ca/disassemblies/rom/hex/asm/028E.html">KEY_SCAN</a>.)
  $EC28,$02 Skip character field handling if no player input is registered.
  $EC2A,$01 Advance the character selection index.
  $EC2B,$02 Skip to #R$EC71 if the selection index has overflowed.
  $EC2D,$01 Step the selection index back by one.
  $EC2E,$02 Set the field count to #N$02.
  $EC30,$04 Load the first cursor column from #R$C500 into #REGc.
  $EC34,$04 Load the first cursor position from #R$C4FD into #REGd.
  $EC38,$04 Point #REGix to the first character table at #R$EE28.
  $EC3C,$03 Adjust the first score entry field via #R$EDAA.
  $EC3F,$04 Write the updated first cursor position back to #R$C4FD.
  $EC43,$02 Skip to #R$EC71 if only the first field was updated.
  $EC45,$02 Set the field count to #N$09.
  $EC47,$04 Load the second cursor column from #R$C501 into #REGc.
  $EC4B,$04 Load the second cursor position from #R$C4FE into #REGd.
  $EC4F,$04 Point #REGix to the second character table at #R$EE2E.
  $EC53,$03 Adjust the second score entry field via #R$EDDD.
  $EC56,$04 Write the updated second cursor position back to #R$C4FE.
  $EC5A,$02 Skip to #R$EC71 if only the second field was updated.
  $EC5C,$02 Set the field count to #N$06.
  $EC5E,$04 Load the third cursor column from #R$C502 into #REGc.
  $EC62,$04 Load the third cursor position from #R$C4FF into #REGd.
  $EC66,$04 Point #REGix to the third character table at #R$EE49.
  $EC6A,$03 Adjust the third score entry field via #R$EDAA.
  $EC6D,$04 Write the updated third cursor position back to #R$C4FF.
@ $EC71 label=High_Score_Entry_Loop_End
  $EC71,$01 Switch to the alternate registers.
  $EC72,$02 Decrement the frame counter and loop back to #R$EC06.
  $EC74,$01 Switch back to the main registers.
@ $EC75 label=High_Score_Display
N $EC75 Name entry complete: clear the display and redraw the final score table
. before the display cycling phase.
  $EC75,$04 Clear the display with attribute #INK$00 via #R$ECA4.
  $EC79,$03 Initialise the scrolling display via #R$F09D.
  $EC7C,$03 Advance the colour cycle via #R$F0EE.
  $EC7F,$03 Render the high score table via #R$F3AE.
  $EC82,$01 Switch to the alternate registers.
  $EC83,$02 Set the display frame counter to #N$32 in #REGb'.
@ $EC85 label=High_Score_Display_Loop
N $EC85 Per-frame display cycling loop: services controls and colour attributes
. for #N$32 frames before returning to the attract mode.
  $EC85,$01 Switch back to the main registers for this frame.
  $EC86,$02 Set the frame delay count to #N$64.
  $EC88,$03 Run the per-frame timing delay via #R$ECDE.
  $EC8B,$03 Check for the BREAK key combination via #R$ECE6.
  $EC8E,$03 Check for the S key via #R$ECFB.
  $EC91,$03 Check for tape save/load keys (J/L) via #R$ED10.
  $EC94,$03 Restart the high score display if any key is held via #R$ED71.
  $EC97,$03 Read the joystick input via #R$ED7C.
  $EC9A,$03 Advance the colour cycle via #R$F0EE.
  $EC9D,$01 Switch to the alternate registers.
  $EC9E,$02 Decrement the frame counter and loop back to #R$EC85.
  $ECA0,$01 Switch back to the main registers.
  $ECA1,$03 Jump to the attract mode loop at #R$F4EC.

c $ECA4 Initialise Display and Set Border
@ $ECA4 label=Initialise_Display_And_Border
D $ECA4 Clears the display pixel area (#N$4000-#N$57FF) to black and fills
. the 768 attribute cells with the byte in #REGa, then derives the border
. colour from #REGa's paper bits and updates both BORDCR (#N$5C48) and
. the ULA border port (#N$FE).
R $ECA4 A Attribute byte for the display fill
  $ECA4,$09 Set up to clear the pixel area (#N$4000-#N$57FF, #N$1800 bytes).
  $ECAD,$04 Clear the first pixel byte and fill the remaining display
. pixels to black via LDIR.
  $ECB1,$03 Set the attribute fill count to #N$0300 cells.
  $ECB4,$03 Seed the first attribute cell with #REGa and fill all #N$0300
. attribute cells via LDIR.
  $ECB7,$02,b$01 Isolate the paper colour bits from the attribute.
  $ECB9,$04 Skip to #R$ECBF if the paper colour is in the upper range
. (#N$04-#N$07).
  $ECBD,$02,b$01 Complement the ink colour bits to contrast with dark paper.
@ $ECBF label=Set_Border_Colour
  $ECBF,$03 #HTML(Write the background colour to *<a href="https://skoolkid.github.io/rom/asm/5C48.html">BORDCR</a>.)
  $ECC2,$02,b$01 Re-isolate the paper colour bits.
  $ECC4,$03 Shift the paper colour into the low 3 bits.
  $ECC7,$02 Write the paper colour to the ULA border port #N$FE.
  $ECC9,$01 Return.
N $ECCA Alternate entry: compute a score character position as #REGa × 8 +
. #REGb and highlight its attribute row via #R$EE0B and #R$EE1D.
@ $ECCA label=Render_Score_Character
  $ECCA,$04 Compute the character position index as #REGa × 8 + #REGb.
  $ECCE,$03 Calculate the attribute cell address for this position via
. #R$EE0B.
  $ECD1,$03 Highlight the score entry row with bright white via #R$EE1D.
  $ECD4,$01 Return.
N $ECD5 Alternate entry: highlight a single score entry attribute cell on
. row #N$59 directly, using #REGa × 2 + 1 as the cell offset.
@ $ECD5 label=Highlight_Score_Entry_Cell
  $ECD5,$04 Compute the attribute cell offset as #REGa × 2 + 1.
  $ECD9,$04 Write #COLOUR$47 to attribute row #N$59 at the computed offset.
  $ECDD,$01 Return.

c $ECDE Display Loop Delay
@ $ECDE label=Display_Loop_Delay
D $ECDE Busy-wait timing delay used by the attract mode and high score display
. loops. Each call resets #REGb to #N$00 and spins the inner busy-wait
. #N$100 times; #REGc controls the outer repetition count. Callers set
. #REGc to #N$64 before the call, giving 100 outer passes of 256 inner
. spins each.
  $ECDE,$02 Set the inner loop counter to #N$00, giving #N$100 busy-wait spins.
@ $ECE0 label=Display_Loop_Delay_Inner
  $ECE0,$02 Spin until the inner loop counter reaches zero.
  $ECE2,$03 Decrement the outer pass count in #REGc and loop back to #R$ECE0.
  $ECE5,$01 Return.

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

c $ECFB Check S Key During Display
@ $ECFB label=Check_S_Key_During_Display
D $ECFB Reads keyboard row #N$FD (A-S-D-F-G) during the high score display loops.
. Forces the upper three bits high and checks for the S key alone. If S is
. the only key held, discards the caller's return address and jumps to the
. tape load continuation handler at #R$D3F8 with the header parameters from
. #R$C4FD and #R$C4FE. Returns normally if no matching key is detected.
  $ECFB,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
  $ECFF,$02,b$01 Force bits 5-7 high.
  $ED01,$03 Return if the S key is not the only key pressed.
  $ED04,$01 Discard the caller's return address from the stack.
  $ED05,$04 Load the tape header byte from #R$C4FD into #REGb.
  $ED09,$04 Load the tape header byte from #R$C4FE into #REGe.
  $ED0D,$03 Jump to the tape load continuation at #R$D3F8.

c $ED10 Save Or Load High Scores
@ $ED10 label=Save_Or_Load_High_Scores
D $ED10 Checks whether J (save) or L (load) is held on keyboard row #N$BF. On
. J, saves the #N$012D-byte score table from #R$F1AB to tape. On L, loads
. from tape into the buffer at #R$6100; a successful load copies the buffer
. to the live score data and restarts the display. A failed load shows a
. tape error message — or a wrong-game warning if a Moon Patrol score table
. was detected — then waits for a keypress before returning.
  $ED10,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
  $ED15,$02,b$01 Isolate the L (bit 1) and J (bit 3) keys.
  $ED17,$01 Return if neither tape key is pressed.
  $ED18,$03 Set the score table byte count to #N$012D.
  $ED1B,$02 Test whether the L key is held for a tape load.
  $ED1D,$04 Set the tape data type identifier to #N$6B and jump to #R$ED2A
. if the L key is held.
N $ED21 J key path: save the score table to tape.
  $ED21,$04 Point #REGix to the score table at #R$F1AB for the tape save.
  $ED25,$03 Save #N$012D bytes to tape via SA_BYTES (#N$04C2).
  $ED28,$02 Disable interrupts and return.
@ $ED2A label=Load_High_Score_Table
N $ED2A L key path: load a score table from tape into the buffer at #R$6100.
  $ED2A,$01 Set the carry flag to signal a data block load to LD_BYTES.
  $ED2B,$04 Point #REGix to the score reception buffer at #R$6100.
  $ED2F,$03 Load #N$012D bytes from tape via LD_BYTES (#N$0556).
  $ED32,$01 Restore #REGde from the stack.
  $ED33,$01 Disable interrupts.
  $ED34,$02 Jump to #R$ED63 if the tape load succeeded.
N $ED36 Load failed: select the appropriate error message.
  $ED36,$01 Read the tape data type marker returned by the load.
  $ED37,$03 Point #REGhl to the tape error message at #R$EFBC.
  $ED3A,$04 Jump to #R$ED41 if the marker is not the Moon Patrol identifier
. #N$6C.
  $ED3E,$03 Select the wrong-game warning at #R$EFDD.
@ $ED41 label=Show_Tape_Message
  $ED41,$01 Stash the message pointer on the stack.
  $ED42,$01 Clear #REGa to prepare for display reinitialisation.
  $ED43,$03 Reinitialise the display via #R$ECA4.
  $ED46,$03 Call #R$F09D.
  $ED49,$03 Call #R$F0EE.
  $ED4C,$01 Restore the message pointer from the stack.
  $ED4D,$03 Print the tape status message via #R$9006.
@ $ED50 label=Tape_Message_Loop
  $ED50,$02 Set the frame delay count to #N$64.
  $ED52,$03 Call #R$ECDE.
  $ED55,$03 Call #R$ED7C.
  $ED58,$03 Call #R$F0EE.
  $ED5B,$03 Check the BREAK key via #R$ECE6.
  $ED5E,$03 Abort if any key is pressed via #R$ED71.
  $ED61,$02 Loop back to #R$ED50.
@ $ED63 label=Install_Loaded_Score_Table
N $ED63 Load succeeded: copy the freshly loaded data from the tape reception
. buffer into the live score table.
  $ED63,$09 Set up the score table copy: source #R$6100, destination
. #R$F1AB, length #N$012D bytes.
  $ED6C,$02 Copy the loaded score table into the live high score data.
  $ED6E,$03 Jump to #R$EC75 to restart the high score display.

c $ED71 Check Any Key During Display
@ $ED71 label=Check_Any_Key_During_Display
D $ED71 Reads all keyboard rows simultaneously (port #N$FE with selector #N$00)
. during the high score display loop. Forces the upper three bits high; if
. any key is pressed, increments #REGa past #N$FF, discards the caller's
. return address, and restarts the high score display at #R$EBC8. Returns
. normally if no keys are held.
  $ED71,$03 Read all keyboard rows simultaneously.
  $ED74,$02,b$01 Force bits 5-7 high.
  $ED76,$02 Return if no keys are pressed (#REGa wraps to #N$00).
  $ED78,$01 Discard the caller's return address from the stack.
  $ED79,$03 Restart the high score display at #R$EBC8.

c $ED7C Scan and Cycle Screen Attributes
@ $ED7C label=Scan_And_Cycle_Screen_Attributes
D $ED7C Scans the entire screen attribute area from #N$5800 to #N$5AFF,
. comparing each attribute byte against the colour substitution table at
. #R$EE49(#N$EE5B). Any matching byte is replaced with its table-defined
. counterpart. Called each frame during the high score display loops to
. cycle the colour state of the score cells.
  $ED7C,$03 Point #REGde to the start of the attribute area at #N$5800.
@ $ED7F label=Scan_Attr_Loop
  $ED7F,$01 Load the current attribute byte from the display.
  $ED80,$06 Set up to search for this attribute in the substitution table
. at #R$EE49(#N$EE5B).
  $ED86,$02 Search for the attribute in the substitution table.
  $ED88,$02 Skip replacement if the attribute was not found.
  $ED8A,$02 Replace the attribute with its substitution byte.
@ $ED8C label=Scan_Attr_Next
  $ED8C,$01 Advance to the next attribute cell.
  $ED8D,$03 Check if the scan has reached the end of the attribute area.
  $ED90,$02 Loop back to #R$ED7F until all attribute cells are processed.
  $ED92,$01 Return.

c $ED93 Scan Score Display Attributes
@ $ED93 label=Scan_Score_Display_Attributes
D $ED93 Scans a contiguous block of attribute cells from #REGde to #REGix,
. applying the same colour substitution as #R$ED7C. Called during the name
. entry phase to keep the score display colours consistent.
R $ED93 DE Start attribute address
R $ED93 IX End attribute address (exclusive)
  $ED93,$01 Load the current attribute byte from #REGde.
  $ED94,$06 Set up to search for this attribute in the substitution table
. at #R$EE49(#N$EE5B).
  $ED9A,$02 Search for the attribute in the substitution table.
  $ED9C,$02 Skip replacement if the attribute was not found.
  $ED9E,$02 Replace the attribute with its substitution byte.
@ $EDA0 label=Scan_Score_Attr_Next
  $EDA0,$01 Advance to the next attribute cell.
  $EDA1,$03 Copy the end address from #REGix to #REGhl.
  $EDA4,$03 Clear carry and test whether the range is exhausted.
  $EDA7,$02 Loop back to #R$ED93 until all cells in the range are processed.
  $EDA9,$01 Return.

c $EDAA Adjust Score Field Cursor
@ $EDAA label=Adjust_Score_Field_Cursor
D $EDAA Adjusts the cursor within a score entry digit field. Searches for the
. current column position in the character table at #REGix via #R$EE02; if
. found and within range, updates #REGe to the new column, calculates the
. attribute address via #R$EE0B, writes highlight attributes for both the
. old and new cursor positions via #R$EE1D, then fills the column bytes for
. the updated field.
R $EDAA B Entry count for table search
R $EDAA C Cursor colour byte
R $EDAA D Cursor upper bound
R $EDAA E Current cursor column
R $EDAA IX Score entry character table
  $EDAA,$03 Copy the character table pointer from #REGix to #REGhl.
  $EDAD,$01 Load the current cursor column from #REGe.
  $EDAE,$04 Stash the field count on the stack and search for the current
. column in the table via #R$EE02.
  $EDB2,$01 Restore the field count from the stack.
  $EDB3,$01 Return if the current position is not found in the table.
  $EDB4,$03 Load the next cursor position from the table and check it
. against the upper bound in #REGd.
  $EDB7,$01 Return if the cursor is already at its maximum.
  $EDB8,$01 Update the cursor column in #REGe.
  $EDB9,$02 Advance and load the screen position byte from the table entry.
  $EDBB,$04 Stash the cursor state on the stack and calculate the new
. attribute cell address via #R$EE0B.
  $EDBF,$01 Restore the cursor state from the stack.
  $EDC0,$03 Write the highlight attributes for the new cursor position via
. #R$EE1D.
  $EDC3,$03 Reload the character table pointer from #REGix to #REGhl.
  $EDC6,$01 Advance to the second table entry.
  $EDC7,$04 Load the upper bound from #REGd and search for it in the table
. via #R$EE02.
  $EDCB,$02 Advance and load the screen position byte from the table entry.
  $EDCD,$04 Stash the cursor state on the stack and calculate the previous
. attribute cell address via #R$EE0B.
  $EDD1,$01 Restore the cursor state from the stack.
  $EDD2,$02 Advance past the table position bytes.
  $EDD4,$02 Set the attribute fill count to #N$1C.
@ $EDD6 label=Score_Field_Fill_Loop
  $EDD6,$04 Write the cursor colour to each attribute cell and loop until
. #N$1C cells are filled.
  $EDDA,$01 Copy the updated cursor column from #REGe to #REGd.
  $EDDB,$02 Clear #REGa and return to signal the field was updated.

c $EDDD Adjust Name Entry Cursor
@ $EDDD label=Adjust_Name_Entry_Cursor
D $EDDD Adjusts the cursor within the name entry character field. Searches for
. the current character position in the table at #REGix via #R$EE02; if
. found and within range, updates #REGe, writes #COLOUR$47 to the new
. character's attribute cell on the #N$59 row directly, then updates the
. previous character's attribute. Simpler than #R$EDAA as it addresses the
. attribute row without calling #R$EE0B.
R $EDDD B Entry count for table search
R $EDDD C Cursor colour byte
R $EDDD D Cursor upper bound
R $EDDD E Current character position
R $EDDD IX Name entry character table
  $EDDD,$03 Copy the character table pointer from #REGix to #REGhl.
  $EDE0,$01 Load the current character position from #REGe.
  $EDE1,$04 Stash the field count on the stack and search for the current
. position in the table via #R$EE02.
  $EDE5,$01 Restore the field count from the stack.
  $EDE6,$01 Return if the current position is not found.
  $EDE7,$03 Load the next character position from the table and check it
. against the upper bound in #REGd.
  $EDEA,$01 Return if the cursor is at its maximum.
  $EDEB,$01 Update the character position in #REGe.
  $EDEC,$02 Advance and read the attribute column offset.
  $EDEE,$04 Set the attribute row to #N$59 and write #COLOUR$47 to
. highlight the new character position.
  $EDF2,$03 Reload the character table pointer from #REGix to #REGhl.
  $EDF5,$01 Advance to the second table entry.
  $EDF6,$04 Load the upper bound from #REGd and search for it in the table
. via #R$EE02.
  $EDFA,$02 Advance and read the previous attribute column offset.
  $EDFC,$03 Set the attribute row to #N$59 and write the cursor colour to
. the previous character position.
  $EDFF,$01 Copy the updated character position from #REGe to #REGd.
  $EE00,$02 Clear #REGa and return to signal the character was updated.

c $EE02 Search Score Entry Table
@ $EE02 label=Search_Score_Entry_Table
D $EE02 Searches a 3-byte-strided table at #REGhl for the value in #REGa,
. scanning up to #REGb entries. Returns with the Z flag set and #REGhl
. pointing to the matched entry if found, or the Z flag clear if not found.
R $EE02 A Byte to search for
R $EE02 B Entry count
R $EE02 HL Table pointer
  $EE02,$02 Return if the current table entry matches.
  $EE04,$03 Advance #REGhl by 3 bytes to the next table entry.
  $EE07,$02 Decrement the entry count and loop back to #R$EE02.
  $EE09,$02 Exhaust the search count and return without a match.

c $EE0B Calculate Attribute Cell Address
@ $EE0B label=Calculate_Attr_Cell_Address
D $EE0B Looks up a character index in the word table at #N$4600 to find its
. pixel row address, then converts that address to the corresponding
. attribute cell in the range #N$5800-#N$5BFF by shifting the screen row
. right by 3 and combining with #N$58. Called by #R$EDAA to position score
. entry highlight attributes.
R $EE0B A Character index
  $EE0B,$08 Look up the character index in the word table at #N$4600 and
. load the pixel row address into #REGhl.
  $EE13,$09 Convert the pixel row address to the attribute cell address in
. the range #N$5800-#N$5BFF.
  $EE1C,$01 Return.

c $EE1D Highlight Score Entry Row
@ $EE1D label=Highlight_Score_Entry_Row
D $EE1D Writes #COLOUR$47 (bright white on black) to #N$1C consecutive
. attribute cells from #REGhl. Called to highlight a complete score entry
. row when the cursor moves.
R $EE1D HL Pointer to the attribute area (advanced by 2 before writing)
  $EE1D,$04 Skip past the table position bytes and set the fill count to
. #N$1C.
@ $EE21 label=Score_Row_Highlight_Loop
  $EE21,$06 Write #COLOUR$47 to each attribute cell and loop until #N$1C
. cells are highlighted.
  $EE27,$01 Return.

b $EE28
b $EE2E
b $EE49 Score Entry Field Three Table
@ $EE49 label=Score_Entry_Field_Three_Table
D $EE49 Six 3-byte entries used by #R$EDAA to adjust the third score entry
. field cursor. Each entry holds: cursor column value, upper bound, and
. screen position byte for attribute address calculation via #R$EE0B.
. Followed immediately by the five find-replace colour substitution pairs
. at #R$EE5B, read each frame by #R$ED7C and #R$ED93.
B $EE49,$12
@ $EE5B label=Colour_Substitution_Table
B $EE5B,$0A
B $EE65,$01

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
  $EFE8,$08 #FONT$8100,attr=$47(WARNING-)(warning)
B $EFF0,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $EFF2,$43 #FONT$8100,attr=$44(You have attempted to load an Atarisoft Moon Patrol Hi-score table.)(moon-patrol)
B $F035,$02 TAB: #N(#PEEK(#PC+$01)).
  $F037,$13 #FONT$8100,attr=$44(Please try again!!!)(try-again)
B $F04A,$02 Set left margin: #N(#PEEK(#PC+$01)).
B $F04C,$01 Terminator.

c $F04D Fill Row
@ $F04D label=Fill_Row
D $F04D Writes the current border colour to #REGd cells starting at
. (H=column, L=row), advancing one column right per cell. Called by
. #R$F063 to paint the top and bottom horizontal edges of each colour ring.
R $F04D HL Starting cell coordinate (H = column, L = row)
R $F04D D Number of cells to fill
  $F04D,$01 Copy the cell count to the loop register.
@ $F04E label=Fill_Row_Loop
  $F04E,$04 Stash the cell coordinate on the stack and plot the border colour.
  $F052,$02 Restore the cell coordinate and advance one column right.
  $F054,$03 Repeat for each remaining cell.
  $F057,$01 Return.

c $F058 Fill Column
@ $F058 label=Fill_Column
D $F058 Writes the current border colour to #REGd cells starting at
. (H=column, L=row), advancing one row down per cell. Called by #R$F063 to
. paint the left and right vertical edges of each colour ring.
R $F058 HL Starting cell coordinate (H = column, L = row)
R $F058 D Number of cells to fill
  $F058,$01 Copy the cell count to the loop register.
@ $F059 label=Fill_Column_Loop
  $F059,$04 Stash the cell coordinate on the stack and plot the border colour.
  $F05D,$02 Restore the cell coordinate and advance one row down.
  $F05F,$03 Repeat for each remaining cell.
  $F062,$01 Return.

c $F063 Draw Colour Ring
@ $F063 label=Draw_Colour_Ring
D $F063 Draws one rectangular colour ring with its top-left corner at column
. #REGb, row #REGc. The horizontal edges span columns #REGb to #N$FF-#REGb
. and are drawn via #R$F04D; the vertical edges span rows #REGc to
. #N$BF-#REGc and are drawn via #R$F058.
R $F063 BC Corner offset (B = column, C = row)
N $F063 Draw the top and bottom horizontal edges.
  $F063,$03 Load the corner position into #REGhl and copy the column to #REGa.
  $F066,$05 Calculate the horizontal edge length as #N$100 minus 2 times
. the column offset.
  $F06B,$05 Stash the corner, draw the top edge rightward via #R$F04D,
. and restore.
  $F070,$05 Set the position to the bottom edge at row #N$BF minus #REGc.
  $F075,$05 Stash the corner, draw the bottom edge rightward via #R$F04D,
. and restore.
N $F07A Draw the left and right vertical edges.
  $F07A,$09 Reset the corner position and calculate the vertical edge length
. as #N$C0 minus 2 times the row offset.
  $F083,$05 Stash the corner, draw the left edge downward via #R$F058,
. and restore.
  $F088,$04 Set the position to the right edge at column #N$FF minus #REGb.
  $F08C,$05 Stash the corner, draw the right edge downward via #R$F058,
. and restore.
  $F091,$01 Return.

c $F092 Draw Concentric Rings
@ $F092 label=Draw_Concentric_Rings
D $F092 Draws #REGd nested rectangular colour rings, each one cell inward
. from the last, by calling #R$F063 with incrementing corner offsets.
R $F092 BC Starting corner offset (B = column, C = row)
R $F092 D Number of rings to draw
  $F092,$05 Stash the ring counter, draw the current colour ring via
. #R$F063, and restore.
  $F097,$02 Move the corner one cell inward on each side.
  $F099,$03 Repeat for each remaining ring.
  $F09C,$01 Return.

c $F09D Draw Colour Border
@ $F09D label=Draw_Colour_Border
D $F09D Draws two sets of four concentric colour rings to build the screen
. colour border: four rings from the outer edge at (#N$00, #N$00), then
. four more from the inner edge at (#N$08, #N$08).
  $F09D,$08 Draw #N$04 concentric rings from the outer screen edge.
  $F0A5,$08 Draw #N$04 concentric rings starting #N$08 cells inward.
  $F0AD,$01 Return.

c $F0AE Fill Border Attributes
@ $F0AE label=Fill_Border_Attributes
D $F0AE Writes the two-colour attribute border frame to attribute RAM at
. #N$5800, using #REGd as the outer border colour and #REGe as the inner
. border colour. The outer colour fills a two-cell-wide band around the
. edge; the inner colour fills the adjacent band one cell inside that.
R $F0AE D Outer border attribute byte
R $F0AE E Inner border attribute byte
  $F0AE,$03 Point #REGhl to the start of the attribute area at #N$5800.
N $F0B1 Fill the top two-row border band.
  $F0B1,$02 Set the outer top row cell count to #N$21.
@ $F0B3 label=Fill_Border_Top_Outer_Loop
  $F0B3,$04 Write the outer border colour to #N$21 consecutive cells.
  $F0B7,$02 Set the inner top row cell count to #N$1E.
@ $F0B9 label=Fill_Border_Top_Inner_Loop
  $F0B9,$04 Write the inner border colour to the next #N$1E cells.
  $F0BD,$02 Write the outer border colour to close the inner top row.
N $F0BF Fill the #N$14 inner rows with border cells on each side.
  $F0BF,$02 Set the inner row counter to #N$14.
@ $F0C1 label=Fill_Border_Inner_Row_Loop
  $F0C1,$02 Write the outer border colour to the left border cell.
  $F0C3,$05 Write the inner border colour and skip #N$1D cells across the
. inner area.
  $F0C8,$02 Write the inner border colour to the last inner cell.
  $F0CA,$02 Write the outer border colour to the right border cell.
  $F0CC,$03 Repeat for each inner row.
N $F0CF Fill the bottom two-row border band.
  $F0CF,$02 Write the outer border colour to close the last inner row.
  $F0D1,$02 Set the inner bottom row cell count to #N$1E.
@ $F0D3 label=Fill_Border_Bottom_Inner_Loop
  $F0D3,$04 Write the inner border colour to the next #N$1E cells.
  $F0D7,$02 Set the outer bottom row cell count to #N$21.
@ $F0D9 label=Fill_Border_Bottom_Outer_Loop
  $F0D9,$04 Write the outer border colour to #N$21 consecutive cells.
  $F0DD,$01 Return.

g $F0DE Border Colour Pairs
@ $F0DE label=Table_Border_Colour_Pairs
D $F0DE Eight outer/inner attribute-byte pairs for the screen border colour
. cycle. Each word is read by #R$F0EE and passed as #REGde to #R$F0AE.
W $F0DE,$02
L $F0DE,$02,$08

c $F0EE Cycle Border Colour
@ $F0EE label=Cycle_Border_Colour
D $F0EE Advances the border colour cycle one step and redraws the attribute
. border frame. Reads the current step from #R$C508, decrements it
. (wrapping at 0 back to 7), looks up the outer/inner attribute pair from
. #R$F0DE, and calls #R$F0AE to repaint the border.
  $F0EE,$04 Read and decrement the border colour step from #R$C508.
  $F0F2,$02,b$01 Mask the step to the range 0–7.
  $F0F4,$03 Store the updated step back to #R$C508.
  $F0F7,$09 Double the step to a word offset and index into the colour pair
. table at #R$F0DE.
  $F100,$03 Load the outer (#REGd) and inner (#REGe) attribute bytes from
. the table.
  $F103,$03 Redraw the screen border with the new colour pair via #R$F0AE.
  $F106,$01 Return.

c $F107 Print BCD Score
@ $F107 label=Print_BCD_Score
D $F107 Prints a BCD-encoded score of #REGb bytes from (HL) as decimal
. digits on screen, suppressing leading zeros. Each zero nibble advances
. the column by #REGc without printing; once a non-zero digit is found,
. all remaining digits are printed. Each digit is positioned using an AT
. sequence (#N$16) via #R$8DCC; #REGd is the starting column, #REGe is
. the row, and #REGd advances by #REGc after each digit.
R $F107 HL Pointer to the BCD score data
R $F107 B Number of BCD bytes
R $F107 C Column step between digits
R $F107 D Starting column position
R $F107 E Row position
  $F107,$02 Set the BCD byte count to #N$04.
N $F109 Leading zero suppression: skip zero nibbles, advancing the column.
@ $F109 label=Print_BCD_Score_Suppress_Loop
  $F109,$0B Read the high nibble of the current score byte; jump to
. #R$F130 to print it if non-zero.
  $F114,$03 Advance the column position past the suppressed high digit.
  $F117,$05 Jump to print the units digit via #R$F147 if this is the
. last byte.
  $F11C,$01 Read the current score byte for the low nibble check.
  $F11D,$02,b$01 Isolate the low nibble.
  $F11F,$02 Jump to print it via #R$F14A if non-zero.
  $F121,$03 Advance the column position past the suppressed low digit.
  $F124,$03 Move to the next score byte and repeat.
N $F127 Digit print loop: print both nibbles of each remaining byte.
@ $F127 label=Print_BCD_Score_Print_Loop
  $F127,$09 Read the high nibble of the current score byte.
@ $F130 label=Print_High_Digit
  $F130,$03 Convert to ASCII and stash the digit character on the stack.
  $F133,$11 Position the cursor at column #REGd, row #REGe via #R$8DCC
. and print the digit character.
  $F144,$03 Advance the column position.
@ $F147 label=Read_Low_Digit
  $F147,$01 Read the current score byte for the low nibble.
  $F148,$02,b$01 Isolate the low nibble.
@ $F14A label=Print_Low_Digit
  $F14A,$03 Convert to ASCII and stash the digit character on the stack.
  $F14D,$11 Position the cursor at column #REGd, row #REGe via #R$8DCC
. and print the digit character.
  $F15E,$03 Advance the column position.
  $F161,$03 Move to the next score byte and repeat.
  $F164,$01 Return.

t $F165 Table: Robotron Heroes
@ $F165 label=Table_RobotronHeroes
N $F165 Position: #N($01+(#PC-$F165)/$07).
  $F165,$03 Name.
B $F168,$04 Score.
L $F165,$07,$0A

t $F1AB Messaging: High Score Name
@ $F1AB label=Messaging_HighScoreName
  $F1AB,$14
B $F1BF,$01 Terminator.

t $F1C0 Table: High Scores
@ $F1C0 label=Table_HighScores
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

c $F2F9 Draw Score Entry
@ $F2F9 label=Draw_Score_Entry
D $F2F9 Draws one score entry on the high score screen. Given the screen
. position in #REGde and the name data in #REGhl, prints the rank number
. from #R$C503, a closing parenthesis, the three-character name, then
. the full score digits via #R$F107. The alternate entry at #R$F343
. uses tighter row spacing and a smaller column advance for the All
. Time Heroes table.
R $F2F9 DE Screen position (row in #REGd, column in #REGe)
R $F2F9 HL Points to the three-character name for this score entry
  $F2F9,$04 Set the rank digit count and row stride.
  $F2FD,$02 Stash the name pointer and screen position on the stack.
  $F2FF,$06 Call #R$F109 using #R$C503.
  $F305,$02 Restore the screen position and name pointer from the stack.
  $F307,$14 Position the cursor and print the closing parenthesis character.
  $F31B,$0F Position the cursor for the score entry name.
  $F32A,$02 Set the name character loop counter.
@ $F32C label=Draw_Score_Entry_Name_Loop
  $F32C,$05 Print the next character of the name.
  $F331,$02 Repeat for the three-character name.
  $F333,$07 Save the screen position and advance the row for the score digits.
  $F33A,$03 Print the score digits via #R$F107.
  $F33D,$05 Restore the position and advance the column for the next entry.
  $F342,$01 Return.
@ $F343 label=Draw_Score_Entry_Compact
N $F343 Compact variant for the All Time Heroes table; uses a row stride
. of #N$04 and a column advance of #N$06 for tighter spacing.
  $F343,$04 Set the rank digit count and row stride.
  $F347,$02 Stash the name pointer and screen position on the stack.
  $F349,$06 Call #R$F109 using #R$C503.
  $F34F,$02 Restore the screen position and name pointer from the stack.
  $F351,$14 Position the cursor and print the closing parenthesis character.
  $F365,$0F Position the cursor for the score entry name.
  $F374,$02 Set the name character loop counter.
@ $F376 label=Draw_Score_Entry_Compact_Name_Loop
  $F376,$05 Print the next character of the name.
  $F37B,$02 Repeat for the three-character name.
  $F37D,$07 Save the screen position and advance the row for the score digits.
  $F384,$03 Print the score digits via #R$F107.
  $F387,$05 Restore the position and advance the column for the next entry.
  $F38C,$01 Return.

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

c $F3AE Display High Score Screen
@ $F3AE label=Display_High_Score_Screen
D $F3AE Displays the high score screen. Prints the five current game scores
. as Robotron Heroes using #R$F2F9, then a second group of five using the
. same routine. Next prints the All Time Heroes table: the top record
. holder name and score are shown at the top, followed by #N$27 all-time
. entries printed in three BCD-indexed columns via #R$F343. Ends with the
. save and load prompt from #R$F45A.
  $F3AE,$06 Call #R$9006 using #R$F2D8.
  $F3B4,$06 Set the starting score index and screen position.
  $F3BA,$03 Point to #R$F165.
@ $F3BD label=Display_High_Score_Screen_Loop1
  $F3BD,$03 Set the current score entry index.
  $F3C0,$01 Stash the entry index on the stack.
  $F3C1,$03 Draw this score entry.
  $F3C4,$01 Restore the entry index from the stack.
  $F3C5,$01 Advance to the next score entry.
  $F3C6,$04 Repeat until all five entries have been drawn.
N $F3CA Print the second group of five current game scores.
  $F3CA,$04 Set the screen position for the second group of five scores.
@ $F3CE label=Display_High_Score_Screen_Loop2
  $F3CE,$01 Stash the entry index on the stack.
  $F3CF,$04 Skip the score index remap if not at the tenth entry.
  $F3D3,$02 Remap the tenth entry index for display.
@ $F3D5 label=Display_High_Score_Screen_Remap
  $F3D5,$03 Set the (possibly remapped) entry index.
  $F3D8,$03 Draw this score entry.
  $F3DB,$01 Restore the entry index from the stack.
  $F3DC,$01 Advance to the next score entry.
  $F3DD,$04 Repeat until all ten entries have been drawn.
N $F3E1 Print the All Time Heroes rankings.
  $F3E1,$06 Call #R$9006 using #R$F38D.
  $F3E7,$06 Call #R$9006 using #R$F1AB.
  $F3ED,$05 Advance past the message and load the top record score.
  $F3F2,$04 Adjust the display row for the top score entry.
  $F3F6,$05 Print the top score position label.
  $F3FB,$05 Print the opening parenthesis of the record holder name.
  $F400,$02 Set the name character loop counter.
@ $F402 label=Display_High_Score_Screen_Name_Loop
  $F402,$05 Load and print each character of the record holder's name.
  $F407,$02 Repeat for the three-character name.
  $F409,$05 Print the closing parenthesis.
  $F40E,$05 Send the font select control code.
  $F413,$05 Send the font parameter byte.
N $F418 Print the all-time score entries across three columns.
  $F418,$06 Set the starting BCD index and position for the first column.
@ $F41E label=Display_High_Score_Screen_Col1
  $F41E,$03 Set the score entry index.
  $F421,$01 Stash the entry index on the stack.
  $F422,$03 Draw this all-time score entry.
  $F425,$01 Restore the entry index from the stack.
  $F426,$05 Advance the BCD index; check if the first column is complete.
  $F42B,$02 Repeat for the next entry until the first column is done.
  $F42D,$04 Set the screen position for the second score column.
@ $F431 label=Display_High_Score_Screen_Col2
  $F431,$03 Set the score entry index.
  $F434,$01 Stash the entry index on the stack.
  $F435,$03 Draw this all-time score entry.
  $F438,$01 Restore the entry index from the stack.
  $F439,$05 Advance the BCD index; check if the second column is complete.
  $F43E,$02 Repeat for the next entry until the second column is done.
  $F440,$04 Set the screen position for the third score column.
@ $F444 label=Display_High_Score_Screen_Col3
  $F444,$03 Set the score entry index.
  $F447,$01 Stash the entry index on the stack.
  $F448,$03 Draw this all-time score entry.
  $F44B,$01 Restore the entry index from the stack.
  $F44C,$05 Advance the BCD index; check if the third column is complete.
  $F451,$02 Repeat for the next entry until the third column is done.
  $F453,$06 Call #R$9006 using #R$F45A.
  $F459,$01 Return.

t $F45A Messaging: Save / Load
@ $F45A label=Messaging_SaveLoad
B $F45A,$03 PRINT AT #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $F45D,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $F45F,$02 BRIGHT: #MAP(#PEEK(#PC+$01))(OFF,1:ON).
B $F461,$02 Select font: #N(#PEEK(#PC+$01)).
  $F463,$24
B $F487,$01 Terminator.

c $F488 Draw Colour Flash Rectangle
@ $F488 label=Draw_Colour_Flash_Rectangle
D $F488 Renders one frame of the extra life colour flash animation. The
. frame index in #REGa controls the inset from the edges: #N$0B paints a
. narrow band near the centre of the attribute area; #N$00 fills the full
. screen border. Each call fills the top row, the left and right border
. cells of each middle row, and the bottom row with the flash colour.
R $F488 A Frame index (#N$00-#N$0B); lower values produce a wider rectangle
  $F488,$03 Point to the start of the attribute area.
  $F48B,$06 Copy the frame index to #REGbc and #REGde.
  $F491,$14 Shift #REGde left by #N$05 to compute the attribute row offset.
  $F4A5,$02 Point to the starting attribute cell for this frame.
  $F4A7,$01 Stash the starting attribute address on the stack.
  $F4A8,$05 Calculate the top row fill width and set the loop counter.
  $F4AD,$03 Save the row fill width.
  $F4B0,$03 Load the flash colour.
@ $F4B3 label=Draw_Colour_Flash_Rectangle_Top
N $F4B3 Fill the top row of the rectangle.
  $F4B3,$04 Fill the top row with the flash colour.
  $F4B7,$05 Restore the row pointer and advance to the next attribute row.
  $F4BC,$06 Calculate the middle row count; jump to #R$F4E0 if none.
  $F4C2,$01 Set the middle section row counter.
  $F4C3,$0B Calculate the stride to the far border cell and save it.
  $F4CE,$03 Load the flash colour.
@ $F4D1 label=Draw_Colour_Flash_Rectangle_Middle
N $F4D1 For each middle row, paint the left and right border cells.
  $F4D1,$0F Paint the left and right border cells and advance to the next row.
@ $F4E0 label=Draw_Colour_Flash_Rectangle_Bottom
N $F4E0 Fill the bottom row of the rectangle.
  $F4E0,$07 Set up to fill the bottom row with the flash colour.
@ $F4E7 label=Draw_Colour_Flash_Rectangle_Bottom_Fill
  $F4E7,$04 Fill the bottom row with the flash colour.
  $F4EB,$01 Return.

c $F4EC Attract Mode Loop
@ $F4EC label=Attract_Mode_Loop
D $F4EC Clears the playfield, sets the background colour to #COLOUR$46, draws
. the title screen layout, and loads the strip blit parameters, then counts
. down #N$32 frames. Each frame checks for BREAK, S key and tape key
. presses, advances the title animation and colour cycle, then jumps to
. the high score entry screen at #R$EBC8 when the counter reaches zero.
  $F4EC,$03 Clear the playfield and reset sprite state via #R$D070.
  $F4EF,$05 Call #R$D07E using #COLOUR$46.
  $F4F4,$03 Draw the title screen layout via #R$F83C.
  $F4F7,$03 Load the title strip blit parameters via #R$F637.
  $F4FA,$02 Initialise the attract mode frame counter to #N$32.
@ $F4FC label=Attract_Mode_Frame_Loop
  $F4FC,$03 Write the frame counter to *#R$C4F8.
  $F4FF,$03 Check for the BREAK key combination via #R$ECE6.
  $F502,$03 Check for the S key via #R$ECFB.
  $F505,$03 Check for tape save/load keys (J/L) via #R$ED10.
  $F508,$03 Restart the high score display if any key is held via #R$ED71.
  $F50B,$03 Advance the title screen animation frame via #R$F7EE.
  $F50E,$03 Advance the title screen colour cycle via #R$F51D.
  $F511,$03 Step the attribute colour ring via #R$F5A0.
  $F514,$03 Load the attract mode frame counter from *#R$C4F8.
  $F517,$01 Decrement the attract mode frame counter.
  $F518,$02 Loop back to #R$F4FC until the counter reaches zero.
  $F51A,$03 Jump to the high score entry screen at #R$EBC8.

c $F51D Advance Colour Cycle
@ $F51D label=Advance_Colour_Cycle
D $F51D Advances the colour cycling animation by one step. Scans all 768
. screen attribute cells and replaces cells matching #N$47 with the next
. colour from the sequence at #R$F54D, then immediately replaces all cells
. matching the following entry with #N$47 to prime the next cycle step.
  $F51D,$03 Load the colour cycle table pointer.
  $F520,$01 Read the replacement colour from the current table entry.
  $F521,$03 Set the attribute value to be replaced.
  $F524,$03 Scan the attribute area and apply the colour replacement.
  $F527,$04 Re-read and advance the colour cycle pointer.
@ $F52B label=Advance_Colour_Cycle_Next
  $F52B,$03 Save the updated colour cycle pointer.
  $F52E,$04 Read the next table entry and check for the end sentinel.
  $F532,$04 Set up to restore the marker colour and scan again.
  $F536,$05 Reset the colour cycle pointer to the table start.
@ $F53B label=Advance_Colour_Cycle_Scan
N $F53B Scan all 768 screen attribute cells and replace any cell colour
. matching the target with the replacement colour.
  $F53B,$06 Set up to scan all 768 screen attribute cells.
@ $F541 label=Advance_Colour_Cycle_Scan_Loop
  $F541,$03 Skip the cell if it does not match the target colour.
  $F544,$01 Write the replacement colour to this attribute cell.
@ $F545 label=Advance_Colour_Cycle_Loop_Next
  $F545,$05 Advance to the next cell and reload the target colour.
  $F54A,$02 Loop back until all attribute cells are scanned.
  $F54C,$01 Return.

b $F54D Colour Cycle Table
@ $F54D label=Colour_Cycle_Table
D $F54D Sequence of ZX Spectrum attribute byte values used to drive the
. colour cycling animation. Each byte specifies the colour to write;
. #N$FF is the end-of-sequence sentinel that resets the pointer to the
. table start.
B $F54D,$07

g $F554 Screen Colour Cycle Pointer
@ $F554 label=Screen_Colour_Cycle_Pointer
D $F554 Self-modifying pointer into #R$F54D. Holds the address of the
. next colour cycle entry to apply on the next call to #R$F51D.
W $F554,$02

b $F556
B $F556,$02

b $F558 Intro Sprite Table
@ $F558 label=Intro_Sprite_Table
D $F558 Table of #N$17 three-byte entries describing the position of each
. sprite on the intro screen. Each entry holds the Y pixel row at +#N$00,
. the X byte column at +#N$01, and the attribute byte at +#N$02.
B $F558,$45,$03
B $F59D,$01

g $F59E Intro Colour Cycle Pointer
@ $F59E label=Intro_Colour_Cycle_Pointer
W $F59E,$02

c $F5A0 Advance Intro Colour Cycle
@ $F5A0 label=Advance_Intro_Colour_Cycle
D $F5A0 Advances the intro screen colour cycling effect by one step.
. Reads source and replacement colours from #R$F5B7 via the pointer at
. #R$F59E, then scans all 768 attribute cells and replaces every cell
. matching the source colour with the replacement.
  $F5A0,$05 Load the colour cycle pointer and read the source colour.
@ $F5A5 label=Advance_Intro_Colour_Cycle_Read
  $F5A5,$05 Read the next cycle entry; jump to #R$F5AF if not the end.
  $F5AA,$05 Reset the colour cycle pointer to the table start.
@ $F5AF label=Advance_Intro_Colour_Cycle_Apply
  $F5AF,$02 Set up the replacement and source colours.
  $F5B1,$03 Save the updated colour cycle pointer.
  $F5B4,$03 Scan the attribute area and apply the colour swap.

b $F5B7 Intro Colour Cycle Table
@ $F5B7 label=Intro_Colour_Cycle_Table
D $F5B7 Sequence of ZX Spectrum attribute byte values cycling the intro
. screen display colours. Consecutive bytes form source/replacement pairs;
. #N$FF is the end sentinel that wraps the pointer to the table start.
B $F5B7,$01 #COLOUR(#PEEK(#PC)).
L $F5B7,$01,$03
B $F5BA,$01 Terminator.

c $F5BB Advance Flash Colour Cycle
@ $F5BB label=Advance_Flash_Colour_Cycle
D $F5BB Advances the extra life colour flash display by one step. Scans all
. 768 attribute cells and replaces each colour with its successor in the
. cycle table at #R$F5D2, rotating the screen through blue, green, cyan,
. white, yellow, magenta, and red on successive calls.
  $F5BB,$03 Point to the start of the attribute area.
@ $F5BE label=Advance_Flash_Colour_Cycle_Scan
  $F5BE,$01 Read the current attribute cell colour.
  $F5BF,$03 Point to the colour cycle table.
  $F5C2,$03 Set the cycle table scan length.
  $F5C5,$02 Scan the table for a matching colour entry.
  $F5C7,$02 Jump to #R$F5CB if no matching entry was found.
  $F5C9,$02 Replace the attribute cell with the next colour in the cycle.
@ $F5CB label=Advance_Flash_Colour_Cycle_Next
  $F5CB,$01 Advance to the next attribute cell.
  $F5CC,$05 Loop back until the entire attribute area has been processed.
  $F5D1,$01 Return.

b $F5D2 Flash Colour Cycle Table
@ $F5D2 label=Flash_Colour_Cycle_Table
D $F5D2 Seven-step colour rotation table used by #R$F5BB. Each byte maps to
. the next in the cycle: blue (#N$09) to green (#N$24) to cyan (#N$2D)
. to white (#N$3F) to yellow (#N$36) to magenta (#N$1B) to red (#N$12)
. and back to blue. The eighth byte repeats the first to wrap the cycle.
B $F5D2,$01 #COLOUR(#PEEK(#PC)).
L $F5D2,$01,$08

c $F5DA Extra Life Flash Effect
@ $F5DA label=Extra_Life_Flash
D $F5DA Creates the extra life award flash effect. Sets the attribute fill
. colour to #N$12 and runs #N$0C screen-flash frames, each calling #R$F488
. to repaint the attribute area and #R$F5BB to advance the colour cycling
. animation. The screen is then wiped by #R$D070 and a second pass of
. #N$0C frames plays with the colour cleared.
  $F5DA,$02 Set the screen flash colour.
  $F5DC,$03 Write the flash colour to the attribute fill register.
  $F5DF,$02 Set the flash loop counter.
@ $F5E1 label=Extra_Life_Flash_Loop1
  $F5E1,$01 Stash the loop counter on the stack.
  $F5E2,$03 Repaint the display with the flash colour.
  $F5E5,$03 Advance the colour cycling animation.
  $F5E8,$01 Restore the loop counter from the stack.
  $F5E9,$05 Decrease the loop counter and loop back for the next frame.
N $F5EE Wipe the screen, clear the flash colour and run a second pass.
  $F5EE,$03 Wipe the screen.
  $F5F1,$05 Clear the attribute fill register.
  $F5F6,$02 Set the second loop counter.
@ $F5F8 label=Extra_Life_Flash_Loop2
  $F5F8,$01 Stash the loop counter on the stack.
  $F5F9,$03 Repaint the display with the cleared colour.
  $F5FC,$03 Advance the colour cycling animation.
  $F5FF,$01 Restore the loop counter from the stack.
  $F600,$05 Decrease the loop counter and loop back for the next frame.
  $F605,$01 Return.

c $F606 OR Blit Title Strips
@ $F606 label=BlitTitleStrips
D $F606 OR-blits horizontal strips of bitmap data from the source pointer in #REGhl
. into the screen buffer, using the four-byte parameter block at #R$C4F9–#R$C4FC.
. *#R$C4F9 seeds the outer strip counter in #REGb; *#R$C4FA drives the screen row
. lookup (with #N$8C00 / #N$8D style indexing); *#R$C4FB is the byte count per strip
. (LDIR length); the loop runs until #REGb reaches *#R$C4FC after each pass.
. Called from #R$F637 with #REGhl pointing at ROM graphics (#R$6D7D and #R$7005).
R $F606 HL Pointer to source bitmap data in ROM
  $F606,$04 #REGb=*#R$C4F9 (initial strip index for #REGb).
@ $F60A label=BlitTitleStrips_Strip
  $F60A,$01 Stash #REGbc on the stack (strip index and loop state).
  $F60B,$01 Stash #REGhl on the stack (source pointer for this strip).
N $F60C Derive a screen destination from *#R$C4FA and the screen row address
. lookup table; combine with the next source byte and OR into the low byte of
. the destination address.
  $F60C,$01 #REGl=#REGb (strip index into the row term).
  $F60D,$02 #REGb=#N$45 (row address table high-byte base, rotated with *#R$C4FA).
  $F60F,$04 #REGc=*#R$C4FA (row / band parameter).
  $F613,$04 Shift #REGc left; rotate into #REGb (table pointer high byte #N$8C / #N$8D).
  $F617,$02 #REGh=#N$46 (row address table base high byte).
  $F619,$04 Shift #REGl left through #REGh (index into the row address table).
  $F61D,$01 #REGa=*(#REGhl) (low byte of the screen row base address).
  $F61E,$01 Advance #REGhl.
  $F61F,$01 #REGh=*(#REGhl) (high byte of the screen row base address).
  $F620,$01 #REGl=#REGa (full row base address in #REGhl).
  $F621,$01 #REGa=*(#REGbc) (source bitmap byte).
  $F622,$01 OR with #REGl (low byte of the screen address).
  $F623,$01 Write merged low byte back to #REGl.
  $F624,$01 Restore destination pointer into #REGde from the stack.
  $F625,$01 Swap #REGde and #REGhl (destination now in #REGhl).
  $F626,$02 Clear #REGb (high byte of LDIR length).
  $F628,$04 #REGc=*#R$C4FB (bytes to OR along this strip).
  $F62C,$02 LDIR copies #REGbc bytes from the source bitmap (#REGhl) into the strip at #REGde.
  $F62E,$01 Restore #REGbc from the stack.
  $F62F,$01 Advance the strip index #REGb by one.
  $F630,$03 #REGa=*#R$C4FC (terminal strip index).
  $F633,$01 Compare #REGa with #REGb.
  $F634,$02 Loop back to #R$F60A until all strips for this bitmap are done.
  $F636,$01 Return.

c $F637 Draw Attract Title
@ $F637 label=DrawAttractTitle
D $F637 Attract-mode title setup after the screen is cleared: writes two parameter
. sets to #R$C4F9–#R$C4FC and OR-blits ROM logos from #R$6D7D and #R$7005 via
. #R$F606, fills #N$C0 attribute cells from #N$5920 with #INK$06 (yellow ink on black
. paper), then prints #R$F670 (copyright / Williams credits) via #R$9006. Called
. from #R$F4EC after #R$F83C.
N $F63A First bitmap: parameters #N$28, #N$20, #N$18, #N$43 then source #R$6D7D.
  $F637,$03 #REGhl=#R$C4F9 (parameter block).
  $F63A,$02 Write #N$28 to *#R$C4F9.
  $F63C,$03 Write #N$20 to *#R$C4FA.
  $F63F,$03 Write #N$18 to *#R$C4FB.
  $F642,$03 Write #N$43 to *#R$C4FC.
  $F645,$03 #REGhl=#R$6D7D (first title / logo bitmap in ROM).
  $F648,$03 Call #R$F606.
N $F64E Second bitmap: parameters #N$4A, #N$58, #N$0A, #N$69 then source #R$7005.
  $F64B,$05 Write #N$4A to *#R$C4F9.
  $F650,$03 Write #N$58 to *#R$C4FA.
  $F653,$03 Write #N$0A to *#R$C4FB.
  $F656,$03 Write #N$69 to *#R$C4FC.
  $F659,$03 #REGhl=#R$7005 (second title / logo bitmap in ROM).
  $F65C,$03 Call #R$F606.
N $F65F Attribute band for the credits line (#N$C0 cells, attribute #INK$06).
  $F65F,$03 #REGhl=#N$5920 (start within the attribute file #N$5800–#N$5AFF).
  $F662,$02 Set a loop counter in #REGb for #N$C0 attributes.
@ $F664 label=DrawAttractTitle_FillAttrs
  $F664,$02 Write #INK$06 (#N$06) to *#REGhl.
  $F666,$01 Advance #REGhl.
  $F667,$02 Decrease counter and loop back to #R$F664 until the band is filled.
  $F669,$06 Call #R$9006 using #R$F670.
  $F66F,$01 Return.

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

c $F6C3 Read Control Input
@ $F6C3 label=Read_Control_Input
D $F6C3 Reads the active control input for the current control mode stored in
. *#R$C4FF. Scales the mode index to a word offset, loads the handler address
. from the table at #R$F6DD, pushes #R$F6D8 as the return address, and jumps
. to the handler. Each handler reads one or more hardware ports and returns
. the direction and fire bits in #REGa. The common landing pad at #R$F6D8
. masks the result to five bits and stores it in #REGb and #REGc.
R $F6C3 O:A Active-low direction and fire bits in the lower five bits
R $F6C3 O:B Copy of #REGa; the #N$F7FE row result in split keyboard mode
R $F6C3 O:C Copy of #REGa; the #N$EFFE row result in split keyboard mode
  $F6C3,$05 Point to the handler table at #R$F6DD and zero #REGd.
  $F6C8,$06 Scale *#R$C4FF to a zero-based word table offset in #REGe.
  $F6CE,$05 Load the handler address from the table.
  $F6D3,$04 Push the return address.
  $F6D7,$01 Dispatch to the control handler.

c $F6D8 Common Control Input Return
@ $F6D8 label=Read_Control_Input_Return
D $F6D8 Common control input return routine.
  $F6D8,$02,b$01 Keep only the lower five control bits.
  $F6DA,$02 Copy the masked input bits to #REGb and #REGc.
  $F6DC,$01 Return.

w $F6DD Control Handler Table
@ $F6DD label=Control_Handler_Table
D $F6DD Six-entry word table of control handler addresses, indexed by control
. mode.
W $F6DD,$0C

c $F6E9 Read Keyboard Combined
@ $F6E9 label=Read_Control_Keyboard_Combined
D $F6E9 Control mode #N$01: reads both keyboard rows via #R$F6FA and ANDs
. them together before returning to #R$F6D8.
  $F6E9,$03 Call #R$F6FA to read both keyboard rows.
  $F6EC,$01 Combine the two row results.
  $F6ED,$01 Return to #R$F6D8.

c $F6EE Read Keyboard Split
@ $F6EE label=Read_Control_Keyboard_Split
D $F6EE Control mode #N$05: reads both keyboard rows separately, returning
. the #N$F7FE row in #REGb and the #N$EFFE row in #REGc.
  $F6EE,$03 Call #R$F6FA to read both keyboard rows.
  $F6F1,$02,b$01 Mask the #N$F7FE row result to five bits.
  $F6F3,$02 Copy the #N$F7FE row result to #REGb and load the #N$EFFE row.
  $F6F5,$02,b$01 Mask the #N$EFFE row result to five bits.
  $F6F7,$01 Store the masked #N$EFFE row result in #REGc.
  $F6F8,$01 Discard the stacked return address.
  $F6F9,$01 Return.

c $F6FA Read Keyboard Rows
@ $F6FA label=Read_Keyboard_Rows
D $F6FA Shared keyboard row subroutine. Reads port #N$EFFE into #REGc and
. port #N$F7FE into #REGa.
  $F6FA,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
  $F6FE,$01 Stash the #N$EFFE row result in #REGc.
  $F6FF,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$F7 | 1 | 2 | 3 | 4 | 5 }
. TABLE#
  $F703,$01 Return.

c $F704 Read Control Kempston
@ $F704 label=Read_Control_Kempston
D $F704 Control mode #N$02: reads Kempston joystick port #N$1F, remaps the
. active-high bits to the game's active-low five-bit format.
  $F704,$02 Read the Kempston joystick port.
  $F706,$02 Zero the bit accumulator.
  $F708,$11 Shuffle the Kempston active-high direction and fire bits into the
. game's active-low format.
  $F719,$02 Transfer the remapped bits to #REGa and invert to active-low.
  $F71B,$02,b$01 Force the upper three bits high to match the inactive-key state.
  $F71D,$01 Return to #R$F6D8.

c $F71E Read Control Sinclair
@ $F71E label=Read_Control_Sinclair
D $F71E Control mode #N$03: reads keyboard ports #N$F7FE and #N$EFFE four
. times, extracting one direction or fire bit from each read.
  $F71E,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$F7 | 1 | 2 | 3 | 4 | 5 }
. TABLE#
  $F723,$02,b$01 Isolate bit 4 from the first row.
  $F725,$01 Save the masked result.
  $F726,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
  $F72A,$02,b$01 Isolate bit 0 from the second row.
  $F72C,$02 Merge with and save the accumulated result.
  $F72E,$02 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
  $F730,$02,b$01 Isolate bits 3 and 4 from this read.
  $F732,$02 Shift the isolated bits into position.
  $F734,$02 Merge with and save the accumulated result.
  $F736,$02 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$EF | 0 | 9 | 8 | 7 | 6 }
. TABLE#
  $F738,$02,b$01 Isolate bit 2 from this read.
  $F73A,$02 Shift into position and merge with the accumulated result.
  $F73C,$01 Return to #R$F6D8.

c $F73D Read Control Fuller
@ $F73D label=Read_Control_Fuller
D $F73D Control mode #N$04: reads the Fuller Box joystick port #N$7F (active-
. high bits; fire is at bit 7) and remaps direction and fire bits to the
. game's active-low format.
  $F73D,$02 Read from the joystick;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$7F | UP | DOWN | LEFT | RIGHT | - }
. TABLE#
  $F73F,$02,b$01 Mask to the relevant direction bits.
  $F741,$02 Save the raw input and rotate one position.
  $F743,$02,b$01 Force the upper five bits high.
  $F745,$01 Save the rotated result.
  $F746,$01 Reload the raw input.
  $F747,$02,b$01 Isolate bit 3 from the raw input.
  $F749,$01 Merge with the rotated result.
  $F74A,$01 Save the combined result.
  $F74B,$01 Reload the raw input.
  $F74C,$02,b$01 Isolate bit 2 from the raw input.
  $F74E,$02 Shift the bit into position.
  $F750,$01 Merge with the combined result.
  $F751,$01 Return to #R$F6D8.

c $F752 Read Control Cursor
@ $F752 label=Read_Control_Cursor
D $F752 Cursor keyboard control: reads the Q (up), A (down), O (left) and P
. (right) keys from ports #N$FBFE, #N$FDFE and #N$DFFE, combining the four
. direction bits into the control byte.
  $F752,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
  $F757,$02,b$01 Isolate bit 0 from the first row.
  $F759,$01 Shift the bit into position.
  $F75A,$01 Save the partial result.
  $F75B,$02 Switch to keyboard port #N$FBFE.
  $F75D,$02 Read keyboard port #N$FBFE.
  $F75F,$02,b$01 Isolate bit 0 from the second row.
  $F761,$01 Merge with the first row result.
  $F762,$02 Shift and save the combined result.
  $F764,$02 Switch to keyboard port #N$DFFE.
  $F766,$02 Read keyboard port #N$DFFE.
  $F768,$02,b$01 Isolate bits 0 and 1 from the third row.
  $F76A,$03 Shift the bits into position.
  $F76D,$01 Merge with the accumulated result.
  $F76E,$01 Return to #R$F6D8.

c $F76F XOR Blit Sprite
@ $F76F label=XorBlitSprite
D $F76F Takes the two-byte position entry at #REGhl (byte #N$00 = Y pixel row,
. byte #N$01 = X byte column) and the attribute byte in #REGe (shadow;
. bit 7 set = erase mode, bit 7 clear = draw mode). Computes each screen
. pixel address by reading the row base from the screen row lookup table at #N$8C00
. (indexed by Y) and adding the X column byte offset stored in shadow #REGd.
. XORs #N$04 bytes of the fixed bitmap at #N$6CFC into consecutive screen pixel
. memory for each of #N$20 pixel rows (#N$04 attribute-cell rows of #N$08 pixel
. rows each). After the first pixel row of each attribute-cell row, derives the
. attribute memory high byte from the pixel address high byte and writes the
. attribute byte to #N$04 consecutive attribute cells — suppressed in erase mode.
R $F76F HL Pointer to the two-byte position entry (Y pixel row at +0, X byte column at +1)
N $F76F Initialise the bitmap source (#REGhl=#N$6CFC via EX DE,HL) and compute #REGix
. into the screen row lookup table at #N$8C00, indexed by the Y pixel row. The row is
. shifted left into the lookup table index directly (#REGix=#N$8C00 + Y × #N$02). Store
. the X column byte offset in shadow #REGd and set the outer loop count
. (#REGc=#N$04, shadow, one iteration per attribute-cell row of #N$08 pixel rows).
  $F76F,$03 #REGde=#N$6CFC (bitmap source base address; becomes #REGhl via EX DE,HL).
  $F772,$02 #REGb=#N$46 (initial high byte; becomes #N$8C or #N$8D after RL #REGb).
  $F774,$01 #REGc=Y pixel row (byte #N$00 of the position entry).
  $F775,$01 Advance #REGhl to byte #N$01 (X byte column).
  $F776,$02 SLA #REGc; carry = bit 7 of Y (selects high byte #N$8C or #N$8D).
  $F778,$02 RL #REGb; #REGb=#N$8C (or #N$8D if carry set) — high byte of lookup table pointer.
  $F77A,$01 Stash #REGbc on the stack.
  $F77B,$01 #REGa=X byte column (byte #N$01 of the position entry).
  $F77C,$01 Switch to the shadow registers.
  $F77D,$01 #REGd=X byte column offset (held in shadow across all loop iterations).
  $F77E,$01 Switch back to the normal registers.
  $F77F,$02 POP #REGix; #REGix=#N$8C00 + Y × #N$02 (pointer into the screen row address table).
  $F781,$01 #REGhl=#N$6CFC (bitmap source pointer); #REGde=old #REGhl (discarded).
  $F782,$01 Switch to the shadow registers.
  $F783,$02 #REGc=#N$04 (shadow, outer loop count: #N$04 attribute-cell rows).
  $F785,$01 Switch back to the normal registers.
@ $F786 label=XorBlitSprite_OuterLoop
N $F786 Outer loop (#N$04 iterations, one per attribute-cell row of #N$08 pixel rows).
. Compute the screen pixel address for the first row of this attribute cell:
. read shadow #REGd (X column), add the lookup table low byte from *(#REGix) to give
. #REGe, then read the lookup table high byte from *(#REGix+#N$01) into #REGd. Advance
. #REGix by two to the next lookup table entry.
  $F786,$01 Switch to the shadow registers.
  $F787,$01 #REGa=#REGd (X byte column offset).
  $F788,$01 Switch back to the normal registers.
  $F789,$03 #REGa += *(#REGix) (row table low byte); low byte of screen pixel address.
  $F78C,$02 Advance #REGix to the lookup table high byte.
  $F78E,$01 #REGe=#REGa (low byte of screen pixel address).
  $F78F,$03 #REGd=*(#REGix) (row table high byte of screen pixel address).
  $F792,$02 Advance #REGix to the next lookup table entry.
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
. row). Compute the screen address from the lookup table and XOR #N$04 bitmap bytes into
. pixel memory. No attribute write.
  $F7C2,$01 Switch to the shadow registers.
  $F7C3,$01 #REGa=#REGd (X byte column offset).
  $F7C4,$01 Switch back to the normal registers.
  $F7C5,$03 #REGa += *(#REGix) (row table low byte for this pixel row).
  $F7C8,$02 Advance #REGix to the lookup table high byte.
  $F7CA,$01 #REGe=#REGa (low byte of screen pixel address).
  $F7CB,$03 #REGd=*(#REGix) (row table high byte of screen pixel address).
  $F7CE,$02 Advance #REGix to the next lookup table entry.
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

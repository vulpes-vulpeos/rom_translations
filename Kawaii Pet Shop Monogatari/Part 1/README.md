# Cute Pet Shop Story English translation [WIP]
Last updated: 2026.03.31.

Currently I need help with:
- title screen tiles/tilesmap decompressor-compressor. Assembly responsible for decompression is in decomp_asm.txt.Tiles are around 0x54a02.
- Proofreading. I'm neither a Japanese nor an English native speaker. This translation heavily relied on DeepSeek. Also, most strings were translated without completing the game.
- Increasing width of some menus by 1.

There also is neovim function to convert string to byte array in neovim_func.txt  

The game has main latin chars in it (I've only added: ' - 0xDC, ... - 0xe4).

Ist line can have 17+control char, or just 18 chars (game text engine automatically moves text to next line).
2nd line is the same.
Control chars are:
- F0 - | - new line.
- F1 - @ - data insertion.
- F2- ???
- F3 - wait for button press. (* - F3 + F4).
- F4 - clear lines in dialog box.
- F7 - fade textbox animation.
- F8 - ^ - player name.
- F9 - # - number.
- FA - ~ - animal kind, item name.

**To use patcher:**
- change path defined in ROM_PATH inside rom_patcher.c
- compile with ```gcc rom_patcher.c -o rom_patcher```
- run ```./rom_patcher```

**Rom:** c8ff99c216603ff09733bb4f80e2bc61 Kawaii Pet Shop Monogatari (J) (GB) \[!\].gbc

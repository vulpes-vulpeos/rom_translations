#!/usr/bin/env bash
set -euo pipefail

[[ $# -eq 1 ]] || { echo "Usage: $0 path/to/file.gbc"; exit 1; }

ROM="$1"
[[ -f "$ROM" ]] || { echo "Error: file not found: $ROM"; exit 1; }

EXPECTED_MD5="078c1192e19c1332171d088dcb891293"

if command -v md5sum >/dev/null 2>&1; then
    ACTUAL_MD5=$(md5sum "$ROM" | awk '{print $1}')
elif command -v md5 >/dev/null 2>&1; then
    ACTUAL_MD5=$(md5 -q "$ROM")
else
    echo "Error: neither md5sum nor md5 is available"
    exit 1
fi

if [[ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]]; then
    echo "Error: MD5 checksum mismatch"
    echo "Expected: $EXPECTED_MD5"
    echo "Actual:   $ACTUAL_MD5"
    exit 1
fi


replace_asm() {
    local offset
    offset=$(( $1 ))
    local hex="$2"
    # Normalize (remove spaces, lowercase):
    hex=$(echo "$hex" | tr -d ' ' | tr 'A-F' 'a-f')
    # Convert hex string to binary and write at offset
    printf '%b' "$(echo "$hex" | sed 's/../\\x&/g')" | dd of="$ROM" bs=1 seek="$offset" conv=notrunc status=none
}

replace_tmln() {
    local offset
    offset=$(( $1 ))
    local hex="$2"
    # Normalize (remove spaces, lowercase):
    hex=$(echo "$hex" | tr -d ' ' | tr 'A-F' 'a-f')
    # Validate: exactly 20 bytes = 40 hex chars
    [[ "$hex" =~ ^[0-9a-f]{40}$ ]] || { echo "Error: hex string must describe exactly 20 bytes: $hex"; exit 1; }
    # Convert hex string to binary and write at offset
    printf '%b' "$(echo "$hex" | sed 's/../\\x&/g')" | dd of="$ROM" bs=1 seek="$offset" conv=notrunc status=none
}

replace_tile() {
    local offset
    offset=$(( $1 ))
    local hex="$2"
    # Normalize (remove spaces, lowercase):
    hex=$(echo "$hex" | tr -d ' ' | tr 'A-F' 'a-f')
    # Validate: exactly 16 bytes = 32 hex chars
    [[ "$hex" =~ ^[0-9a-f]{32}$ ]] || { echo "Error: hex string must describe exactly 16 bytes: $hex"; exit 1; }
    # Convert hex string to binary and write at offset
    printf '%b' "$(echo "$hex" | sed 's/../\\x&/g')" | dd of="$ROM" bs=1 seek="$offset" conv=notrunc status=none
}

# printf "0x%X\n" $((rom_offset - bank * 0x4000))
# printf "0x%X\n" $((rel_offset + bank * 0x4000))
# replace strings map table (bank 5)
#                      1     2     3     4     5     6     7     8     1     2     3     4     5     6  |  7     8     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16
replace_asm 0x1bb30 "70 7b 7c 7b 88 7b 94 7b a0 7b ac 7b b8 7b c4 7b d0 7b dc 7b e8 7b f4 7b 00 7c 0c 7c 30 7d 3c 7d 48 7d 54 7d 60 7d 6c 7d 78 7d 84 7d 90 7d 9c 7d a8 7d b4 7d c0 7d cc 7d d8 7d e4 7d f0 7d fc 7d"
# replace strings (bank 5)
replace_asm 0x1bb70 "26 1e 11 23 14 1d 1d 10 ff ff ff ff" # 1 umbrella
replace_asm 0x1bb7c "1c 10 1e 10 1e 14 24 19 1a ff ff ff" # 2 kamameshi
replace_asm 0x1bb88 "1e 10 1a 1d 11 20 29 ff ff ff ff ff" # 3 mailbox
replace_asm 0x1bb94 "25 20 1e 11 24 25 20 1f 14 ff ff ff" # 4 tombstone
replace_asm 0x1bba0 "24 26 1f 15 1a 24 19 ff ff ff ff ff" # 5 sunfish
replace_asm 0x1bbac "13 20 16 ff ff ff ff ff ff ff ff ff" # 6 dog
replace_asm 0x1bbb8 "25 26 23 25 1d 14 ff ff ff ff ff ff" # 7 turtle
replace_asm 0x1bbc4 "24 22 26 1a 23 23 14 1d ff ff ff ff" # 8 squirrel

replace_asm 0x1bbd0 "25 10 13 21 20 1d 14 ff ff ff ff ff" # 1 tadpole
replace_asm 0x1bbdc "21 20 25 10 25 20 ff ff ff ff ff ff" # 2 potato
replace_asm 0x1bbe8 "20 28 1d ff ff ff ff ff ff ff ff ff" # 3 owl
replace_asm 0x1bbf4 "10 21 21 1d 14 ff ff ff ff ff ff ff" # 4 apple
replace_asm 0x1bc00 "12 10 25 15 1a 24 19 ff ff ff ff ff" # 5 catfish
replace_asm 0x1bc0c "24 25 23 10 28 11 14 23 23 2a ff ff" # 6 strawberry

replace_asm 0x1bd30 "12 20 23 1f ff ff ff ff ff ff ff ff" # 7 corn
replace_asm 0x1bd3c "24 14 10 24 19 14 1d 1d ff ff ff ff" # 8 seashell

replace_asm 0x1bd48 "15 10 12 25 20 23 2a ff ff ff ff ff" # 1 factory
replace_asm 0x1bd54 "28 10 16 20 1f ff ff ff ff ff ff ff" # 2 wagon
replace_asm 0x1bd60 "12 23 20 28 ff ff ff ff ff ff ff ff" # 3 crow
replace_asm 0x1bd6c "15 20 23 1c 1d 1a 15 25 ff ff ff ff" # 4 forklift
replace_asm 0x1bd78 "14 1d 14 21 19 10 1f 25 ff ff ff ff" # 5 elephant
replace_asm 0x1bd84 "15 26 23 0d 24 14 10 1d ff ff ff ff" # 6 fur seal
replace_asm 0x1bd90 "12 10 23 ff ff ff ff ff ff ff ff ff" # 7 car
replace_asm 0x1bd9c "1e 20 25 20 23 12 1a 12 1d 14 ff ff" # 8 motorcicle

replace_asm 0x1bda8 "11 1a 12 2a 12 1d 14 ff ff ff ff ff" # 9 bicycle
replace_asm 0x1bdb4 "24 22 26 1a 13 ff ff ff ff ff ff ff" # 10 squid
replace_asm 0x1bdc0 "25 26 23 11 20 0d 24 10 2b 10 14 ff" # 11 turbo sazae
replace_asm 0x1bdcc "1e 1a 29 14 23 0d 25 23 26 12 1c ff" # 12 mixer truck
replace_asm 0x1bdd8 "1e 10 1f 25 1a 24 ff ff ff ff ff ff" # 13 mantis
replace_asm 0x1bde4 "1b 14 1d 1d 2a 15 1a 24 19 ff ff ff" # 14 jellyfish
replace_asm 0x1bdf0 "28 10 24 21 ff ff ff ff ff ff ff ff" # 15 wasp
replace_asm 0x1bdfc "24 26 23 15 1a 1f 16 ff ff ff ff ff" # 16 surfing
# replace hieroglyphs with latin chars :'<,'>s/./ 0&/g
replace_asm 0x1a6f4 "07 07 00 00 03 03 03 00 00 00 03 00 00 00 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03" #a 10
replace_asm 0x1a727 "07 07 03 03 03 03 03 00 00 03 00 00 00 00 03 00 03 00 00 00 00 03 00 03 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 00" #b 11
replace_asm 0x1a75a "07 07 00 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 03 00 03 03 03 03 03 00" #c 12
replace_asm 0x1a78d "07 07 03 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 00" #d 13
replace_asm 0x1a7c0 "07 07 03 03 03 03 03 03 03 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 03" #e 14
replace_asm 0x1a7f3 "07 07 03 03 03 03 03 03 03 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00" #f 15
replace_asm 0x1a826 "07 07 00 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 00 03 00 00 03 03 03 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 03 03 03 03 00" #g 16
replace_asm 0x1a859 "06 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 03 00 00 00 00 03 03 00 00 00 00" #. 17
replace_asm 0x1a8b8 "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03" #h 19
replace_asm 0x1a8eb "07 07 03 03 03 03 03 03 03 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 03 03 03 03 03 03 03" #i 1a
replace_asm 0x1a91e "07 07 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 03 03 03 03 00" #h 1b
replace_asm 0x1a951 "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 03 03 00 03 03 03 03 00 00 00 03 00 00 00 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03" #k 1c
replace_asm 0x1a984 "07 07 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 03" #l 1d
replace_asm 0x1a9b7 "07 07 03 03 03 00 03 03 00 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03" #m 1e
replace_asm 0x1a9ea "07 07 03 00 00 00 00 00 03 03 03 00 00 00 00 03 03 00 03 00 00 00 03 03 00 00 03 00 00 03 03 00 00 00 03 00 03 03 00 00 00 00 03 03 03 00 00 00 00 00 03" #n 1f
replace_asm 0x1aa1d "07 07 00 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 03 03 03 03 00" #o 20
replace_asm 0x1aa50 "07 07 03 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00" #p 21
replace_asm 0x1aa83 "07 07 00 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 03 00 03 03 00 00 00 00 03 03 00 03 03 03 03 03 03" #q 22
replace_asm 0x1aab6 "07 07 03 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 03 03 03 03 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03" #r 23
replace_asm 0x1aae9 "07 07 00 03 03 03 03 03 03 03 00 00 00 00 00 00 03 00 00 00 00 00 00 00 03 03 03 03 03 00 00 00 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 03 00" #s 24
replace_asm 0x1ab1c "07 07 03 03 03 03 03 03 03 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00" #t 25
replace_asm 0x1ab4f "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 03 03 03 03 00" #u 26
replace_asm 0x1ab82 "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 00 00 00 03 00 00 00 03 00 03 00 00 00 00 00 03 00 00 00" #v 27
replace_asm 0x1abb5 "07 07 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 03 00 00 03 00 00 03 00 03 03 00 03 03 03" #w 28
replace_asm 0x1abe8 "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 00 00 00 03 00 00 00 03 03 03 00 00 00 03 00 00 00 03 00 03 00 00 00 00 00 03 03 00 00 00 00 00 03" #x 29
replace_asm 0x1ac1b "07 07 03 00 00 00 00 00 03 03 00 00 00 00 00 03 03 00 00 00 00 00 03 00 03 03 00 03 03 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00 00 00 00 03 00 00 00" #y 2a
replace_asm 0x1ac4e "07 07 03 03 03 03 03 03 03 00 00 00 00 00 00 03 00 00 00 00 03 03 00 00 00 00 03 00 00 00 00 03 03 00 00 00 00 03 00 00 00 00 00 00 03 03 03 03 03 03 03" #z 2b

#TITLE SCREEN
replace_tmln 0x253c8 "41 42 41 46 b6 b7 b8 b9 ba a4 a5 a6 a2 ab ac a3 52 41 43 41"
replace_tmln 0x25608 "41 42 41 46 b6 b7 b8 b9 ba a4 a5 a6 a2 ab ac a3 52 41 43 41"
# Thinking Puzzles [8T]
replace_tile 0x24fa8 "00 17 a0 b7 80 b1 a4 b5 b0 b5 b4 b5 b5 b5 ff ff"
replace_tile 0x24fb8 "00 7f 80 ff 00 45 10 55 00 54 01 55 00 55 ff ff"
replace_tile 0x24fc8 "00 df 20 ff 00 51 04 55 80 d5 00 55 00 55 aa ff"
replace_tile 0x24fd8 "00 ff 00 ff 00 1c 61 7d 00 5c 01 5d 00 1d e2 ff"
replace_tile 0x24fe8 "00 ff 00 ff 00 54 03 57 00 56 81 d5 20 e4 1b ff"
replace_tile 0x24e88 "00 fd 00 fd 00 45 30 75 88 ed 10 dd 00 45 ba ff"
replace_tile 0x24e98 "00 ff 00 ff 00 11 46 57 00 11 6c 7d 00 11 ee ff"
replace_tile 0x24ea8 "00 ff 00 ff 00 ff 00 ff 00 ff 00 ff 00 ff 00 ff"
# Issue 2 [3T]
replace_tile 0x24ef8 "00 7f 00 7f 00 44 19 5d 00 44 33 77 00 44 bb ff"
replace_tile 0x24f08 "00 ff 00 ff 00 54 81 d5 00 54 05 55 64 64 ff ff"
replace_tile 0x24e78 "00 FF 00 FF 01 71 1D 7D 71 71 F7 F7 71 71 FF FF"
# PUSH START
replace_tmln 0x25428 "a1 3c a1 3c a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 3d a1 3d a1"
replace_tmln 0x25448 "3e 3f 3e 3f 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 40 3e 40 3e"
replace_tmln 0x25468 "a1 3c a1 3c A1 8A B0 A0 B1 A1 A0 84 85 86 87 88 3d a1 3d a1" # PUSH START
replace_tmln 0x25488 "3e 3f 3e 3f 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 40 3e 40 3e"
replace_tmln 0x254a8 "3e 3f 3e 3f 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 40 3e 40 3e"

# GAME SELECTION
replace_tmln 0x26648 "29 35 2B 2C C0 C1 C2 C3 C4 B6 B7 B8 2C BA BB B4 2C 2D 35 28"
# Thinking Puzzles [8T]
replace_tile 0x26548 "1f 1f b7 b7 b7 b7 b1 b1 b5 b5 00 b5 00 b5 00 b5"
replace_tile 0x26558 "ff ff 7d 7d fd fd 45 45 55 55 00 54 00 55 00 55"
replace_tile 0x26568 "ff ff df df ff ff 51 51 55 55 00 d5 00 55 00 55"
replace_tile 0x26578 "ff ff ff ff ff ff 1c 1c 7d 7d 00 5c 00 5d 00 1d"
replace_tile 0x26588 "ff ff ff ff ff ff 54 54 57 57 00 56 00 d5 00 e4"
replace_tile 0x264a8 "fd fd fd fd fd fd 45 45 75 75 00 ed 00 dd 00 45"
replace_tile 0x264b8 "ff ff ff ff ff ff 11 11 57 57 00 11 00 7d 00 11"
replace_tile 0x264c8 "ff ff ff ff ff ff ff ff ff ff 00 ff 00 ff 00 ff"
# Issue 2 [3T]
replace_tile 0x264e8 "7f 7f 7f 7f 7f 7f 44 44 5d 5d 00 44 00 77 00 44"
replace_tile 0x264f8 "ff ff ff ff ff ff 54 54 d5 d5 00 54 00 55 00 64"
replace_tile 0x26488 "FF FF FF FF FF FF 71 71 7D 7D 00 71 00 F7 00 71"

# Sudoku
## Normal [4x2T]
replace_tile 0x25e48 "f1 ff f7 ff f7 ff f7 ff f1 ff fd ff fd ff f1 ff"
replace_tile 0x25e58 "ff ff fd ff fd ff 51 ff 55 ff 55 ff 55 ff 91 ff"
replace_tile 0x25e68 "ff ff f7 ff f7 ff 15 ff 55 ff 53 ff 55 ff 15 ff"
replace_tile 0x25e78 "ff ff ff ff ff ff 5f ff 5f ff 5f ff 5f ff 9f ff"
replace_tile 0x25f48 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x25f58 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x25f68 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x25f78 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## Selected [4x2T]
replace_tile 0x25948 "0e 0e 08 08 08 08 08 08 0e 0e 02 02 02 02 0e 0e"
replace_tile 0x25958 "00 00 02 02 02 02 ae ae aa aa aa aa aa aa 6e 6e"
replace_tile 0x25968 "00 00 08 08 08 08 ea ea aa aa ac ac aa aa ea ea"
replace_tile 0x25978 "00 00 00 00 00 00 a0 a0 a0 a0 a0 a0 a0 a0 60 60"
replace_tile 0x25988 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25998 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x259a8 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x259b8 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# Slitherlink
## Normal [6x2T]
replace_tile 0x26048 "fc ff fd ff fd ff fd ff fc ff ff ff ff ff fc ff"
replace_tile 0x26058 "5f ff d6 ff de ff d4 ff 56 ff 56 ff 56 ff 56 ff"
replace_tile 0x26068 "ff ff df ff df ff 44 ff d5 ff d4 ff d5 ff 54 ff"
replace_tile 0x26078 "fd ff fd ff fd ff 45 ff 5d ff 5d ff dd ff 5d ff"
replace_tile 0x26088 "ff ff 7d ff fd ff 45 ff 55 ff 54 ff 55 ff 55 ff"
replace_tile 0x26098 "ff ff ff ff ff ff 7f ff 7f ff ff ff 7f ff 7f ff"
replace_tile 0x26148 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x26158 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x26168 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x26178 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x26188 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x26198 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## Selected [6x2T]
replace_tile 0x259c8 "03 03 02 02 02 02 02 02 03 03 00 00 00 00 03 03"
replace_tile 0x259d8 "a0 a0 29 29 21 21 2b 2b a9 a9 a9 a9 a9 a9 a9 a9"
replace_tile 0x259e8 "00 00 20 20 20 20 bb bb 2a 2a 2b 2b 2a 2a ab ab"
replace_tile 0x259f8 "02 02 02 02 02 02 ba ba a2 a2 a2 a2 22 22 a2 a2"
replace_tile 0x25a08 "00 00 82 82 02 02 ba ba aa aa ab ab aa aa aa aa"
replace_tile 0x25a18 "00 00 00 00 00 00 80 80 80 80 00 00 80 80 80 80"
replace_tile 0x25a28 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25a38 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25a48 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25a58 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25a68 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25a78 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# Nonogram
## Normal [6x2T]
replace_tile 0x260a8 "fe ff fe ff fe ff fe ff fe ff fe ff fe ff fe ff"
replace_tile 0x260b8 "3f ff bf ff bf ff a2 ff aa ff aa ff aa ff a2 ff"
replace_tile 0x260c8 "ff ff ff ff ff ff 22 ff aa ff aa ff aa ff a2 ff"
replace_tile 0x260d8 "ff ff ff ff ff ff 22 ff ee ff ae ff ae ff 2e ff"
replace_tile 0x260e8 "ff ff ff ff ff ff 20 ff aa ff 2a ff aa ff aa ff"
replace_tile 0x260f8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261a8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261b8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261c8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261d8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261e8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x261f8 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## Selected [6x2T]
replace_tile 0x25a88 "01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01"
replace_tile 0x25a98 "c0 c0 40 40 40 40 5d 5d 55 55 55 55 55 55 5d 5d"
replace_tile 0x25aa8 "00 00 00 00 00 00 dd dd 55 55 55 55 55 55 5d 5d"
replace_tile 0x25ab8 "00 00 00 00 00 00 dd dd 11 11 51 51 51 51 d1 d1"
replace_tile 0x25ac8 "00 00 00 00 00 00 df df 55 55 d5 d5 55 55 55 55"
replace_tile 0x25ad8 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25ae8 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25af8 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25b08 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25b18 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25b28 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x25b38 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"

# PAUSE MENU
# Pencil [4T]
replace_tile 0x280bb "e0 e0 a0 a0 a0 a0 ae ae ea ea 8e 8e 88 88 8e 8e"
replace_tile 0x280cb "00 00 00 00 00 00 ee ee a8 a8 a8 a8 a8 a8 ae ae"
replace_tile 0x280db "20 20 a0 a0 20 20 a0 a0 a0 a0 a0 a0 a0 a0 a0 a0"
replace_tile 0x280eb "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
## Apply [3T]
replace_tile 0x281cb "e0 e0 a0 a0 a0 a0 ae ae ea ea ae ae a8 a8 a8 a8"
replace_tile 0x281db "08 08 08 08 08 08 ea ea aa aa eb eb 88 88 8b 8b"
replace_tile 0x281eb "00 00 00 00 00 00 80 80 80 80 80 80 80 80 80 80"
## Cancel [5T]
replace_tile 0x281fb "e0 e0 80 80 80 80 8e 8e 8a 8a 8e 8e 8a 8a ea ea"
replace_tile 0x2820b "00 00 00 00 00 00 ee ee a8 a8 a8 a8 a8 a8 ae ae"
replace_tile 0x2821b "08 08 08 08 08 08 e8 e8 a8 a8 e8 e8 88 88 e8 e8"
replace_tile 0x2822b "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x2823b "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# Restart [5T]
replace_tile 0x280fb "e0 e0 a0 a0 a0 a0 ae ae ca ca ae ae a8 a8 ae ae"
replace_tile 0x2810b "00 00 04 04 04 04 ee ee 84 84 e4 e4 24 24 e6 e6"
replace_tile 0x2811b "00 00 00 00 00 00 ee ee a8 a8 e8 e8 a8 a8 a8 a8"
replace_tile 0x2812b "00 00 40 40 40 40 e0 e0 40 40 40 40 40 40 60 60"
replace_tile 0x2813b "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# Give up [4T]
replace_tile 0x2814b "e0 e0 88 88 80 80 8a 8a aa aa aa aa aa aa e9 e9"
replace_tile 0x2815b "00 00 00 00 00 00 b8 b8 a8 a8 b8 b8 a0 a0 38 38"
replace_tile 0x2816b "00 00 00 00 00 00 ae ae aa aa ae ae a8 a8 68 68"
replace_tile 0x2817b "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# Suspend [3T]
replace_tile 0x2818b "c0 c0 80 80 80 80 95 95 d5 d5 55 55 54 54 cd cd"
replace_tile 0x2819b "00 00 00 00 00 00 bb bb 2a 2a bb bb a2 a2 a3 a3"
replace_tile 0x281ab "00 00 01 01 01 01 77 77 55 55 55 55 55 55 57 57"

# INGAME
# Pencil mode icon [4T]
## ingame Sudoku
replace_tile 0x0e421 "7f ff c0 ff bf c0 bb c0 b7 c6 af cf bf cf bf c7"
replace_tile 0x0e441 "fe ff 03 ff fd 03 fd 03 fd 03 fd 03 fd 83 fd c3"
replace_tile 0x0e431 "bf c3 bf c1 bf c0 bf c0 bf c0 bf c0 c0 ff 7f ff"
replace_tile 0x0e451 "fd e3 fd f3 cd c3 dd 53 fd 03 fd 03 03 ff fe ff"
## ???
replace_tile 0x1f6cd "7f ff c0 ff bf c0 bb c0 b7 c6 af cf bf cf bf c7"
replace_tile 0x1f6dd "fe ff 03 ff fd 03 fd 03 fd 03 fd 03 fd 83 fd c3"
replace_tile 0x1f6ed "bf c3 bf c1 bf c0 bf c0 bf c0 bf c0 c0 ff 7f ff"
replace_tile 0x1f6fd "fd e3 fd f3 cd c3 dd 53 fd 03 fd 03 03 ff fe ff"
## pause menu
replace_tile 0x2849b "7f ff c0 ff bf c0 bb c0 b7 c6 af cf bf cf bf c7"
replace_tile 0x284ab "fe ff 03 ff fd 03 fd 03 fd 03 fd 03 fd 83 fd c3"
replace_tile 0x284bb "bf c3 bf c1 bf c0 bf c0 bf c0 bf c0 c0 ff 7f ff"
replace_tile 0x284cb "fd e3 fd f3 cd c3 dd 53 fd 03 fd 03 03 ff fe ff"

#ingame slitherlink (bank 10)
replace_asm 0x2c28e "02 03 03 03 03 03 03 03 03 03 03 03 03 03 03 02"
replace_asm 0x2c29e "03 03 02 02 02 02 02 02 02 02 02 02 02 02 03 03"
replace_asm 0x2c2ae "03 02 01 01 01 01 01 01 01 01 01 01 01 01 02 03"
replace_asm 0x2c2be "03 02 01 01 01 00 01 01 01 01 01 01 01 01 02 03"
replace_asm 0x2c2ce "03 02 01 01 00 03 03 01 01 01 01 01 01 01 02 03"
replace_asm 0x2c2de "03 02 01 00 03 03 03 03 01 01 01 01 01 01 02 03"
replace_asm 0x2c2ee "03 02 01 01 03 03 03 03 03 01 01 01 01 01 02 03"
replace_asm 0x2c2fe "03 02 01 01 01 03 03 03 03 03 01 01 01 01 02 03"
replace_asm 0x2c30e "03 02 01 01 01 01 03 03 03 03 03 01 01 01 02 03"
replace_asm 0x2c31e "03 02 01 01 01 01 01 03 03 03 03 03 01 01 02 03"
replace_asm 0x2c32e "03 02 01 01 01 01 01 01 03 03 00 00 01 01 02 03"
replace_asm 0x2c33e "03 02 01 01 01 01 01 01 01 03 00 03 01 01 02 03"
replace_asm 0x2c34e "03 02 01 01 01 01 01 01 01 01 01 01 01 01 02 03"
replace_asm 0x2c35e "03 02 01 01 01 01 01 01 01 01 01 01 01 01 02 03"
replace_asm 0x2c36e "03 03 02 02 02 02 02 02 02 02 02 02 02 02 03 03"
replace_asm 0x2c37e "02 03 03 03 03 03 03 03 03 03 03 03 03 03 03 02"

# ingame nonograma (bank 5?)
replace_asm 0x19592 "ff 03 03 03 03 03 03 03 03 03 03 03 03 03 03 ff"
replace_asm 0x195a2 "03 03 ff ff ff ff ff ff ff ff ff ff ff ff 03 03"
replace_asm 0x195b2 "03 ff 01 01 01 01 01 01 01 01 01 01 01 01 ff 03"
replace_asm 0x195c2 "03 ff 01 01 01 00 01 01 01 01 01 01 01 01 ff 03"
replace_asm 0x195d2 "03 ff 01 01 00 03 03 01 01 01 01 01 01 01 ff 03"
replace_asm 0x195e2 "03 ff 01 00 03 03 03 03 01 01 01 01 01 01 ff 03"
replace_asm 0x195f2 "03 ff 01 01 03 03 03 03 03 01 01 01 01 01 ff 03"
replace_asm 0x19602 "03 ff 01 01 01 03 03 03 03 03 01 01 01 01 ff 03"
replace_asm 0x19612 "03 ff 01 01 01 01 03 03 03 03 03 01 01 01 ff 03"
replace_asm 0x19622 "03 ff 01 01 01 01 01 03 03 03 03 03 01 01 ff 03"
replace_asm 0x19632 "03 ff 01 01 01 01 01 01 03 03 00 00 01 01 ff 03"
replace_asm 0x19642 "03 ff 01 01 01 01 01 01 01 03 00 03 01 01 ff 03"
replace_asm 0x19652 "03 ff 01 01 01 01 01 01 01 01 01 01 01 01 ff 03"
replace_asm 0x19662 "03 ff 01 01 01 01 01 01 01 01 01 01 01 01 ff 03"
replace_asm 0x19672 "03 03 ff ff ff ff ff ff ff ff ff ff ff ff 03 03"
replace_asm 0x19682 "ff 03 03 03 03 03 03 03 03 03 03 03 03 03 03 ff"

# RESUME MENU
# Sudoku [4x2T]
replace_tile 0x0b943 "ff ff ff ff ff ff ff ff 1f 1f 7f 7f 7f 7f 75 75"
replace_tile 0x0b953 "15 15 d5 d5 d5 d5 19 19 ff ff ff ff ff ff ff ff"
replace_tile 0x0b963 "ff ff ff ff ff ff ff ff ff ff df df df df 11 11"
replace_tile 0x0b973 "55 55 55 55 55 55 11 11 ff ff ff ff ff ff ff ff"
replace_tile 0x0b983 "ff ff ff ff ff ff ff ff ff ff 7f 7f 7f 7f 55 55"
replace_tile 0x0b993 "55 55 35 35 55 55 59 59 ff ff ff ff ff ff ff ff"
replace_tile 0x0b9A3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b9B3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
# Slitherlink [6x2T]
replace_tile 0x0b9e3 "ff ff ff ff ff ff ff ff 17 17 75 75 77 77 75 75"
replace_tile 0x0b9f3 "15 15 d5 d5 d5 d5 15 15 ff ff ff ff ff ff ff ff"
replace_tile 0x0ba03 "ff ff ff ff ff ff ff ff ff ff b7 b7 b7 b7 11 11"
replace_tile 0x0ba13 "b5 b5 b5 b5 b5 b5 95 95 ff ff ff ff ff ff ff ff"
replace_tile 0x0ba23 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x0ba33 "57 57 17 17 77 77 17 17 ff ff ff ff ff ff ff ff"
replace_tile 0x0ba43 "ff ff ff ff ff ff ff ff 7f 7f 5f 5f 7f 7f 51 51"
replace_tile 0x0ba53 "55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff"
replace_tile 0x0ba63 "ff ff ff ff ff ff ff ff ff ff 7f 7f 7f 7f 5f 5f"
replace_tile 0x0ba73 "5f 5f 3f 3f 5f 5f 5f 5f ff ff ff ff ff ff ff ff"
replace_tile 0x0ba83 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0ba93 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
# Nonogram [6x2T]
replace_tile 0x0baa3 "ff ff ff ff ff ff ff ff 1f 1f 5f 5f 5f 5f 51 51"
replace_tile 0x0bab3 "55 55 55 55 55 55 51 51 ff ff ff ff ff ff ff ff"
replace_tile 0x0bac3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x0bad3 "55 55 55 55 55 55 51 51 ff ff ff ff ff ff ff ff"
replace_tile 0x0bae3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x0baf3 "77 77 57 57 57 57 17 17 ff ff ff ff ff ff ff ff"
replace_tile 0x0bb03 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 10 10"
replace_tile 0x0bb13 "55 55 15 15 55 55 55 55 ff ff ff ff ff ff ff ff"
replace_tile 0x0bb23 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 7f 7f"
replace_tile 0x0bb33 "7f 7f 7f 7f 7f 7f 7f 7f ff ff ff ff ff ff ff ff"
replace_tile 0x0bb43 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0bb53 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
# top left/right from resume previous game?
#replace_tile 0x0aed3 ""
replace_tile 0x0aef3 "0f 0f ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
# Resume previous game? [16Tx2]
replace_tile 0x0af03 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af13 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af23 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af33 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af43 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af53 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af63 "00 00 ff ff ff ff ff ff ff ff 1f 1f 5f 5f 5f 5f"
replace_tile 0x0af73 "51 51 35 35 51 51 57 57 51 51 ff ff ff ff ff ff"
replace_tile 0x0af83 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0af93 "15 15 75 75 15 15 d5 d5 19 19 ff ff ff ff ff ff"
replace_tile 0x0afa3 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0afb3 "04 04 55 55 54 54 55 55 54 54 ff ff ff ff ff ff"
replace_tile 0x0afc3 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0afd3 "71 71 75 75 71 71 f7 f7 77 77 ff ff ff ff ff ff"
replace_tile 0x0afe3 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0aff3 "11 11 75 75 71 71 77 77 71 71 ff ff ff ff ff ff"
replace_tile 0x0b003 "00 00 ff ff ff ff ff ff ff ff ff ff f7 f7 ff ff"
replace_tile 0x0b013 "54 54 55 55 55 55 55 55 b4 b4 ff ff ff ff ff ff"
replace_tile 0x0b023 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b033 "54 54 55 55 54 54 57 57 64 64 ff ff ff ff ff ff"
replace_tile 0x0b043 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b053 "71 71 f7 f7 75 75 75 75 71 71 ff ff ff ff ff ff"
replace_tile 0x0b063 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b073 "10 10 55 55 15 15 55 55 55 55 ff ff ff ff ff ff"
replace_tile 0x0b083 "00 00 ff ff ff ff ff ff ff ff fc fc fd fd fd fd"
replace_tile 0x0b093 "47 47 56 56 46 46 5f 5f 46 46 ff ff ff ff ff ff"
replace_tile 0x0b0a3 "00 00 ff ff ff ff ff ff ff ff 7f 7f 7f 7f 7f 7f"
replace_tile 0x0b0b3 "7f 7f 7f 7f ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b0c3 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b0d3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b0e3 "00 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b0f3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"

# Yes [4+1T]
## normal
replace_tile 0x0b103 "ff ff ff ff ff ff ff ff ff ff ff ff 5f ff 5f ff"
replace_tile 0x0b113 "5f ff 51 ff 15 ff d1 ff d7 ff 11 ff ff ff ff ff"
replace_tile 0x0b123 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b133 "ff ff 1f ff 7f ff 1f ff df ff 1f ff ff ff ff ff"
replace_tile 0x0b1a3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## selected
replace_tile 0x0b1c3 "00 00 00 00 00 00 00 00 00 00 00 00 a0 a0 a0 a0"
replace_tile 0x0b1d3 "a0 a0 ae ae ea ea 2e 2e 28 28 ee ee 00 00 00 00"
replace_tile 0x0b1e3 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x0b1f3 "00 00 e0 e0 80 80 e0 e0 20 20 e0 e0 00 00 00 00"
replace_tile 0x0b263 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
# No [6+1T]
## normal
replace_tile 0x0b143 "ff ff ff ff ff ff ff ff 1f ff 5f ff 5f ff 51 ff"
replace_tile 0x0b153 "55 ff 55 ff 55 ff 51 ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b163 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b173 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b183 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b193 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x0b1b3 "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## selected
replace_tile 0x0b203 "00 00 00 00 00 00 00 00 e0 e0 a0 a0 a0 a0 ae ae"
replace_tile 0x0b213 "aa aa aa aa aa aa ae ae 00 00 00 00 00 00 00 00"
replace_tile 0x0b223 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x0b233 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x0b243 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x0b253 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x0b273 "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"

# SUSPEND SCREEN [18x2+1T]
## ???
replace_tile 0x1f47d "aa 55 ff ff ff ff f5 f5 f5 f5 f5 f5 f5 f5 f1 f1"
replace_tile 0x1f48d "aa 55 ff ff ff ff ff ff ff ff ff ff 15 15 55 55"
replace_tile 0x1f49d "aa 55 ff ff ff ff ff ff ff ff ff ff c4 c4 dd dd"
replace_tile 0x1f4ad "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 57 57"
replace_tile 0x1f4bd "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x1f4cd "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x1f4dd "aa 55 ff ff ff ff 7f 7f 7f 7f 7f 7f 57 57 57 57"
replace_tile 0x1f4ed "aa 55 ff ff ff ff ff ff bf bf bf bf 15 15 b5 b5"
replace_tile 0x1f4fd "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x1f50d "aa 55 ff ff ff ff ff ff ed ed ed ed c4 c4 ed ed"
replace_tile 0x1f51d "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 57 57"
replace_tile 0x1f52d "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 55 55"
replace_tile 0x1f53d "aa 55 ff ff ff ff ff ff ff ff ff ff 54 54 55 55"
replace_tile 0x1f54d "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 5f 5f"
replace_tile 0x1f55d "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 57 57"
replace_tile 0x1f56d "aa 55 ff ff ff ff ff ff ff ff ff ff 1c 1c 7d 7d"
replace_tile 0x1f57d "aa 55 ff ff ff ff ff ff ff ff ff ff 45 45 55 55"
replace_tile 0x1f58d "aa 55 ff ff ff ff ff ff ff ff ff ff 5f 5f 5f 5f"
replace_tile 0x1f59d "fd fd fd fd f1 f1 ff ff ff ff ff ff aa 55 00 ff" # bot
replace_tile 0x1f5ad "55 55 55 55 19 19 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f5bd "dc dc dd dd c5 c5 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f5cd "57 57 57 57 57 57 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f5dd "11 11 d5 d5 15 15 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f5ed "11 11 77 77 71 71 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f5fd "47 47 77 77 47 47 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f60d "b5 b5 b5 b5 99 99 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f61d "75 75 75 75 75 75 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f62d "ed ed ed ed e5 e5 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f63d "47 47 5f 5f 47 47 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f64d "15 15 75 75 71 71 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f65d "54 54 55 55 04 04 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f66d "5f 5f df df 5f 5f ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f67d "51 51 57 57 17 17 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f68d "1d 1d 7d 7d 7d 7d ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f69d "55 55 55 55 44 44 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f6ad "5f 5f 5f 5f 1f 1f ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x1f6bd "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"
## When pressing suspend in pause menu
replace_tile 0x2824b "aa 55 ff ff ff ff f5 f5 f5 f5 f5 f5 f5 f5 f1 f1"
replace_tile 0x2825b "aa 55 ff ff ff ff ff ff ff ff ff ff 15 15 55 55"
replace_tile 0x2826b "aa 55 ff ff ff ff ff ff ff ff ff ff c4 c4 dd dd"
replace_tile 0x2827b "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 57 57"
replace_tile 0x2828b "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x2829b "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x282ab "aa 55 ff ff ff ff 7f 7f 7f 7f 7f 7f 57 57 57 57"
replace_tile 0x282bb "aa 55 ff ff ff ff ff ff bf bf bf bf 15 15 b5 b5"
replace_tile 0x282cb "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 75 75"
replace_tile 0x282db "aa 55 ff ff ff ff ff ff ed ed ed ed c4 c4 ed ed"
replace_tile 0x282eb "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 57 57"
replace_tile 0x282fb "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 55 55"
replace_tile 0x2830b "aa 55 ff ff ff ff ff ff ff ff ff ff 54 54 55 55"
replace_tile 0x2831b "aa 55 ff ff ff ff ff ff ff ff ff ff 47 47 5f 5f"
replace_tile 0x2832b "aa 55 ff ff ff ff ff ff ff ff ff ff 11 11 57 57"
replace_tile 0x2833b "aa 55 ff ff ff ff ff ff ff ff ff ff 1c 1c 7d 7d"
replace_tile 0x2834b "aa 55 ff ff ff ff ff ff ff ff ff ff 45 45 55 55"
replace_tile 0x2835b "aa 55 ff ff ff ff ff ff ff ff ff ff 5f 5f 5f 5f"
replace_tile 0x2836b "fd fd fd fd f1 f1 ff ff ff ff ff ff aa 55 00 ff" # bot
replace_tile 0x2837b "55 55 55 55 19 19 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2838b "dc dc dd dd c5 c5 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2839b "57 57 57 57 57 57 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283ab "11 11 d5 d5 15 15 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283bb "11 11 77 77 71 71 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283cb "47 47 77 77 47 47 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283db "b5 b5 b5 b5 99 99 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283eb "75 75 75 75 75 75 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x283fb "ed ed ed ed e5 e5 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2840b "47 47 5f 5f 47 47 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2841b "15 15 75 75 71 71 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2842b "54 54 55 55 04 04 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2843b "5f 5f df df 5f 5f ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2844b "51 51 57 57 17 17 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2845b "1d 1d 7d 7d 7d 7d ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2846b "55 55 55 55 44 44 ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2847b "5f 5f 5f 5f 1f 1f ff ff ff ff ff ff aa 55 00 ff"
replace_tile 0x2848b "ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff"

# Options menu
# Change tile map
replace_tmln 0x31acf "06 06 06 06 06 06 20 21 23 24 26 06 06 06 06 06 06 06 06 06" # How to play item
replace_tmln 0x31aef "06 06 06 06 06 06 30 31 33 34 36 06 06 06 06 06 06 06 06 06"
replace_tmln 0x31b2f "06 06 06 06 06 06 29 2a 2b 2c 2d 2e 2f 27 06 06 06 06 06 06" # Delete save data item
replace_tmln 0x31b4f "06 06 06 06 06 06 39 3a 3b 3c 3d 3e 3f 28 06 06 06 06 06 06"
replace_tmln 0x31bef "06 06 06 06 06 06 06 06 06 06 06 06 06 06 42 43 44 46 47 48"
replace_tile 0x306ef "5F FF 5F FF 55 FF 55 FF 55 FF 55 FF B9 FF FF FF" #42 [Vu]
replace_tile 0x306ff "7F FF 7F FF 44 FF 55 FF 44 FF 5D FF 5C FF FF FF" #43 [lpe]
replace_tile 0x3070f "FF FF FF FF 44 FF 55 FF 54 FF D7 FF 44 FF FF FF" #44 [eos]
replace_tile 0x3072f "FF FF FF FF 71 FF FD FF 71 FF 77 FF 71 FF FF FF" #46 [s 2]
replace_tile 0x3073f "FF FF FF FF 11 FF 5D FF 51 FF 57 FF 11 FF FF FF" #47 [02]
replace_tile 0x3074f "FF FF FF FF 1F FF 7F FF 1F FF 5F FF 1F FF FF FF" #48 [6 ]
## How to play item tiles
replace_tile 0x304cf "ff ff ff ff ff ff ff ff 5f 5f 5f 5f 5f 5f 51 51"
replace_tile 0x304df "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 57 57"
replace_tile 0x304ff "ff ff ff ff ff ff ff ff ff ff bf bf bf bf 11 11"
replace_tile 0x3050f "ff ff ff ff ff ff ff ff fd fd fd fd fd fd c5 c5"
replace_tile 0x3052f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 15 15"
replace_tile 0x305cf "15 15 55 55 55 55 51 51 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x305df "57 57 57 57 57 57 07 07 ff ff ff ff ff ff ff ff"
replace_tile 0x305ff "b5 b5 b5 b5 b5 b5 91 91 ff ff ff ff ff ff ff ff"
replace_tile 0x3060f "d5 d5 c5 c5 dd dd dd dd ff ff ff ff ff ff ff ff"
replace_tile 0x3062f "55 55 11 11 5d 5d 51 51 ff ff ff ff ff ff ff ff"
## Delete save data item tiles
replace_tile 0x3055f "ff ff ff ff ff ff ff ff 3f 3f 5f 5f 5f 5f 51 51"
replace_tile 0x3056f "ff ff ff ff ff ff ff ff 7f 7f 7f 7f 7e 7e 44 44"
replace_tile 0x3057f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 47 47"
replace_tile 0x3058f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x3059f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 51 51"
replace_tile 0x305af "ff ff ff ff ff ff ff ff ff ff f7 f7 f7 f7 c4 c4"
replace_tile 0x305bf "ff ff ff ff ff ff ff ff ff ff ef ef ef ef 44 44"
replace_tile 0x3053f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 7f 7f"
replace_tile 0x3065f "55 55 51 51 57 57 31 31 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x3066f "56 56 46 46 5e 5e 46 46 ff ff ff ff ff ff ff ff"
replace_tile 0x3067f "d7 d7 c7 c7 df df 47 47 ff ff ff ff ff ff ff ff"
replace_tile 0x3068f "75 75 11 11 d5 d5 15 15 ff ff ff ff ff ff ff ff"
replace_tile 0x3069f "55 55 51 51 57 57 b1 b1 ff ff ff ff ff ff ff ff"
replace_tile 0x306af "d5 d5 d4 d4 d5 d5 c5 c5 ff ff ff ff ff ff ff ff"
replace_tile 0x306bf "6d 6d 6c 6c 6d 6d 65 65 ff ff ff ff ff ff ff ff"
replace_tile 0x3054f "7f 7f 7f 7f 7f 7f 7f 7f ff ff ff ff ff ff ff ff"

# Delete save data dialog
# Change tile map
replace_tmln 0x31c4f "06 06 40 41 41 41 41 45 41 41 41 41 4a 41 41 41 41 4f 06 06"
replace_tmln 0x31c6f "06 06 50 06 06 06 06 55 56 57 58 59 5a 06 06 06 06 5f 06 06"
replace_tmln 0x31c8f "06 06 50 06 06 06 06 60 61 62 06 64 06 06 06 06 06 5f 06 06"
replace_tmln 0x31caf "06 06 6e 6d 6d 6d 6d 66 67 68 6d 6a 6d 6d 6d 6d 6d 6f 06 06"

## Are you sure?
replace_tile 0x306df "00 00 00 ff ff 00 ff ff ff ff ff ff ff ff ff ff"
replace_tile 0x3071f "00 00 00 ff ff 00 ff ff ff ff 1f 1f 5f 5f 5f 5f"
replace_tile 0x3076f "00 00 00 ff ff 00 ff ff ff ff f1 f1 f5 f5 fd fd"
replace_tile 0x3081f "51 51 17 17 57 57 57 57 57 57 ff ff ff ff ff ff" # bot
replace_tile 0x3082f "1d 1d 5d 5d 1c 1c 7f 7f 1c 1c ff ff ff ff ff ff"
replace_tile 0x3083f "45 45 55 55 55 55 55 55 46 46 ff ff ff ff ff ff"
replace_tile 0x3084f "71 71 77 77 71 71 7d 7d 71 71 ff ff ff ff ff ff"
replace_tile 0x3085f "51 51 57 57 57 57 57 57 97 97 ff ff ff ff ff ff"
replace_tile 0x3086f "1d 1d 59 59 1b 1b 7f 7f 1b 1b ff ff ff ff ff ff"
## Yes
## normal
replace_tile 0x308cf "ff ff ff ff ff ff fd ff fd ff fd ff fd ff fc ff"
replace_tile 0x308df "ff ff ff ff ff ff 7f ff 7f ff 7f ff 44 ff 55 ff"
replace_tile 0x308ef "ff ff ff ff ff ff ff ff ff ff ff ff 7f ff ff ff"
replace_tile 0x3092f "ff ff ff ff fc ff ff ff ff ff ff 00 00 ff 00 00" # bot
replace_tile 0x3093f "44 ff 5f ff 44 ff ff ff ff ff ff 00 00 ff 00 00"
replace_tile 0x3094f "7f ff 7f ff 7f ff ff ff ff ff ff 00 00 ff 00 00"
## selected
replace_tile 0x302cf "00 00 00 00 00 00 02 02 02 02 02 02 02 02 03 03"
replace_tile 0x302df "00 00 00 00 00 00 80 80 80 80 80 80 bb bb aa aa"
replace_tile 0x302ef "00 00 00 00 00 00 00 00 00 00 00 00 80 80 00 00"
replace_tile 0x303cf "00 00 00 00 03 03 00 00 00 00 00 00 00 00 00 00" # bot
replace_tile 0x303df "bb bb a0 a0 bb bb 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x303ef "80 80 80 80 80 80 00 00 00 00 00 00 00 00 00 00"

## No
## normal
replace_tile 0x3090f "ff ff ff ff ff ff 1f ff 5f ff 5f ff 51 ff 55 ff"
replace_tile 0x3096f "55 ff 55 ff 51 ff ff ff ff ff ff 00 00 ff 00 00"
## selected
replace_tile 0x302ff "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" # top
replace_tile 0x3030f "00 00 00 00 00 00 e0 e0 a0 a0 a0 a0 ae ae aa aa"
replace_tile 0x3031f "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x303ff "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" # bot
replace_tile 0x3040f "aa aa aa aa ae ae 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x3041f "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
replace_tile 0x3042f "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"

## Game selection in save data deletion menu
replace_tmln 0x31f2f "8d 8d 8d 8d 8d 8b 29 2a 2b 2c 2d 2e 2f 27 8d 8d 8d 8d 8d 8d" # Delete save data title
replace_tmln 0x31f4f "8d 8d 8d 8d 8d 8b 39 3a 3b 3c 3d 3e 3f 28 8d 8d 8d 8d 8d 8d"
replace_tmln 0x31f6f "8e 8d 8d 8d 8d 8c 8c 8c 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d"
replace_tmln 0x31fcf "8b 8b 8b 8b 8b 8b ba bb bc 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # Sudoku
replace_tmln 0x31def "8b 8b 8b 8b 8b 8b ca cb cc 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3202f "8b 8b 8b 8b 8b 8b bd be bf d0 d1 8b 8b 8b 8b 8b 8b 8b 8b 8b" # Slitherlink
replace_tmln 0x3204f "8b 8b 8b 8b 8b 8b cd ce cf e0 e1 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3208f "8b 8b 8b 8b 8b 8b d6 d7 d7 d9 da 8b 8b 8b 8b 8b 8b 8b 8b 8b" # Nonogram
replace_tmln 0x320af "8b 8b 8b 8b 8b 8b e6 e7 e8 e9 dd 8b 8b 8b 8b 8b 8b 8b 8b 8b"

# How to play options section
# Change tile map
## Sudoku item in how to menu
replace_tmln 0x31cef "8d 8d 8d 8d 8b 8b 8b 20 21 23 24 26 8b 8b 8b 8d 8d 8d 8d 8d"
replace_tmln 0x31d0f "8d 8d 8d 8d 8b 8b 8b 30 31 33 34 36 8b 8b 8b 8c 8c 8c 8c 8c"
## Title inside sudoku how to menu
replace_tmln 0x3214f "8e 8d 8f 8f 8f 8f 8f 8f 8f 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
replace_tmln 0x3216f "8d 8d 8b 8b ba bb bc 8b 8b 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3218f "8d 8d 8b 8b ca cb cc 8b 8b 8c 8c 8c 8c 8c 8b 88 89 8a 8b 8c"

## Slitherlink item in how to menu
replace_tmln 0x31def "8b 8b 8b 8b 8b 8b bd be bf d0 d1 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x31e0f "8b 8b 8b 8b 8b 8b cd ce cf e0 e1 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Title inside slitherlink menu
replace_tmln 0x3238f "8e 8f 8f 8f 8f 8f 8f 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
replace_tmln 0x323af "8d 8b bd be bf d0 d1 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8d"
replace_tmln 0x323cf "8d 8b cd ce cf e0 e1 8c 8c 8c 8c 8c 8c 8c 8b 88 89 8a 8b 8c"
replace_tmln 0x323ef "8e 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"

## Nonogram item in how to menu
replace_tmln 0x31e4f "8b 8b 8b 8b 8b 8b d6 d7 d7 d9 da 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x31e6f "8b 8b 8b 8b 8b 8b e6 e7 e8 e9 dd 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Title inside nonogram menu
replace_tmln 0x325cf "8e 8f 8f 8f 8f 8f 8f 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
replace_tmln 0x325ef "8d 8b d6 d7 d7 d9 da 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3260f "8d 8b e6 e7 e8 e9 dd 8c 8c 8c 8c 8c 8c 8c 8b 88 89 8a 8b 8c"
replace_tmln 0x3262f "8e 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"

# Sudoku
replace_tile 0x3156f "ff ff ff ff ff ff ff ff 1f 1f 7f 7f 7f 7f 75 75"
replace_tile 0x3157f "ff ff ff ff ff ff ff ff ff ff df df df df 11 11"
replace_tile 0x3158f "ff ff ff ff ff ff ff ff ff ff 7f 7f 7f 7f 55 55"
replace_tile 0x3166f "15 15 d5 d5 d5 d5 19 19 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x3167f "55 55 55 55 55 55 11 11 ff ff ff ff ff ff ff ff"
replace_tile 0x3168f "55 55 35 35 55 55 59 59 ff ff ff ff ff ff ff ff"
# Slitherlink
replace_tile 0x3159f "ff ff ff ff ff ff ff ff 17 17 75 75 77 77 75 75"
replace_tile 0x315af "ff ff ff ff ff ff ff ff f7 f7 b7 b7 b7 b7 11 11"
replace_tile 0x315bf "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x316cf "ff ff ff ff ff ff ff ff 7f 7f 5f 5f 7f 7f 51 51"
replace_tile 0x316df "ff ff ff ff ff ff ff ff ff ff 7f 7f 7f 7f 5f 5f"
replace_tile 0x3169f "15 15 d5 d5 d5 d5 15 15 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x316af "b5 b5 b5 b5 b5 b5 95 95 ff ff ff ff ff ff ff ff"
replace_tile 0x316bf "57 57 17 17 77 77 17 17 ff ff ff ff ff ff ff ff"
replace_tile 0x317cf "55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff"
replace_tile 0x317df "5f 5f 3f 3f 5f 5f 5f 5f ff ff ff ff ff ff ff ff"
# Nonogram
replace_tile 0x3172f "ff ff ff ff ff ff ff ff 1f 1f 5f 5f 5f 5f 51 51"
replace_tile 0x3173f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x3175f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 10 10"
replace_tile 0x3176f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 7f 7f"
replace_tile 0x3182f "55 55 55 55 55 55 51 51 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x3183f "55 55 55 55 55 55 51 51 ff ff ff ff ff ff ff ff"
replace_tile 0x3184f "77 77 57 57 57 57 17 17 ff ff ff ff ff ff ff ff"
replace_tile 0x3185f "55 55 15 15 55 55 55 55 ff ff ff ff ff ff ff ff"
replace_tile 0x3179f "7f 7f 7f 7f 7f 7f 7f 7f ff ff ff ff ff ff ff ff"

# Puzzle help menu items
# Change tile map
## Rules menu item
replace_tmln 0x3220f "8b 8b 8b 8b 8b 8b 91 92 da 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3222f "8b 8b 8b 8b 8b 8b a1 a2 a3 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3244f "8b 8b 8b 8b 8b 8b 91 92 da 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3246f "8b 8b 8b 8b 8b 8b a1 a2 a3 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3268f "8b 8b 8b 8b 8b 8b 91 92 da 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x326af "8b 8b 8b 8b 8b 8b a1 a2 a3 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Sudoku rules title
replace_tmln 0x3282f "8d 8d 8b 91 92 da 8d 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3284f "8d 8d 8b a1 a2 a3 8c 8c 8c 8c 8c 8c 8c 8c 8b 7c 7d 7e 8b 8c"
replace_tmln 0x3286f "8e 8d 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
## Slitherlink rules title
replace_tmln 0x32a6f "8d 8d 8b 91 92 da 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x32a8f "8d 8d 8b a1 a2 a3 8c 8c 8c 8c 8c 8c 8c 8b 7f 80 81 82 83 8c"
replace_tmln 0x32aaf "8e 8d 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
## Nonogram rules title
replace_tmln 0x32caf "8d 8d 8b 91 92 da 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x32ccf "8d 8d 8b a1 a2 a3 8c 8c 8c 8c 8c 8c 8c 8b 84 84 85 86 87 8c"
replace_tmln 0x32cef "8e 8d 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"

## Controls
replace_tmln 0x3226f "8b 8b 8b 8b 8b 8b 99 9a 9b 9c 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3228f "8b 8b 8b 8b 8b 8b a9 aa ab ac 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x324af "8b 8b 8b 8b 8b 8b 99 9a 9b 9c 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x324cf "8b 8b 8b 8b 8b 8b a9 aa ab ac 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x326ef "8b 8b 8b 8b 8b 8b 99 9a 9b 9c 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3270f "8b 8b 8b 8b 8b 8b a9 aa ab ac 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Sudoku controls title
replace_tmln 0x32eef "8d 8d 8b 99 9a 9b 9c 8b 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8d"
replace_tmln 0x32f0f "8d 8d 8b a9 aa ab ac 8b 8c 8c 8c 8c 8c 8c 8b 7c 7d 7e 8b 8c"
replace_tmln 0x32f2f "8e 8d 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
## Slitherlink controls title
replace_tmln 0x332ef "8d 8d 8b 99 9a 9b 9c 8b 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3330f "8d 8d 8b a9 aa ab ac 8b 8c 8c 8c 8c 8c 8b 7f 80 81 82 83 8c"
replace_tmln 0x3332f "8e 8d 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
## Nonogram controls title
replace_tmln 0x3352f "8d 8d 8b 99 9a 9b 9c 8b 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3354f "8d 8d 8b a9 aa ab ac 8b 8c 8c 8c 8c 8c 8b 84 84 85 86 87 8c"
replace_tmln 0x3356f "8e 8d 8c 8c 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"

## Tips
replace_tmln 0x3250f "8b 8b 8b 8b 8b 8b 9f b0 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3252f "8b 8b 8b 8b 8b 8b af c0 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3274f "8b 8b 8b 8b 8b 8b 9f b0 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3276f "8b 8b 8b 8b 8b 8b af c0 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Slitherlink tips title
replace_tmln 0x3376f "8d 8d 8b 9f b0 8b 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x3378f "8d 8d 8b af c0 8b 8c 8c 8c 8c 8c 8c 8c 8b 7f 80 81 82 83 8c"
replace_tmln 0x337af "8e 8d 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"
## Nonogram tips title
replace_tmln 0x33d0f "8d 8d 8b 9f b0 8b 8d 8d 8d 8d 8d 8d 8d 8f 8f 8f 8f 8f 8f 8d"
replace_tmln 0x33d2f "8d 8d 8b af c0 8b 8c 8c 8c 8c 8c 8c 8c 8b 84 84 85 86 87 8c"
replace_tmln 0x33d4f "8e 8d 8c 8c 8c 8c 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8d 8e"

## Rules
replace_tile 0x312df "ff ff ff ff ff ff ff ff 1f 1f 5f 5f 5f 5f 55 55"
replace_tile 0x312ef "ff ff ff ff ff ff ff ff 7f 7f 7f 7f 7f 7f 44 44"

replace_tile 0x313df "35 35 55 55 55 55 59 59 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x313ef "55 55 44 44 5f 5f 44 44 ff ff ff ff ff ff ff ff"
replace_tile 0x313ff "ff ff 7f 7f 7f 7f 7f 7f ff ff ff ff ff ff ff ff"
## Controls
replace_tile 0x3135f "ff ff ff ff ff ff ff ff 1f 1f 7f 7f 7f 7f 71 71"
replace_tile 0x3136f "ff ff ff ff ff ff ff ff ff ff fb fb fb fb 11 11"
replace_tile 0x3137f "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 11 11"
replace_tile 0x3138f "ff ff ff ff ff ff ff ff 7f 7f 7f 7f 7f 7f 47 47"
replace_tile 0x3145f "75 75 75 75 75 75 11 11 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x3146f "5b 5b 5b 5b 5b 5b 59 59 ff ff ff ff ff ff ff ff"
replace_tile 0x3147f "75 75 75 75 75 75 71 71 ff ff ff ff ff ff ff ff"
replace_tile 0x3148f "5f 5f 47 47 77 77 47 47 ff ff ff ff ff ff ff ff"
## Tips
replace_tile 0x313bf "ff ff ff ff ff ff ff ff 1f 1f b7 b7 bf bf b4 b4"
replace_tile 0x314cf "ff ff ff ff ff ff ff ff ff ff ff ff ff ff 47 47"
replace_tile 0x314bf "b5 b5 b4 b4 b5 b5 b5 b5 ff ff ff ff ff ff ff ff" # bot
replace_tile 0x315cf "5f 5f 47 47 f7 f7 c7 c7 ff ff ff ff ff ff ff ff"


# Sudoku rules and controls text
# Change tile map
## Rules
replace_tmln 0x328af "8b 73 00 01 02 03 04 05 06 0f 10 11 12 13 8b 8b 8b 8b 8b 8b" # 1
replace_tmln 0x328cf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x328ef "8b 73 84 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 8b 8b 8b 8b 8b" # 2
replace_tmln 0x3290f "8b 8b 20 21 22 23 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3292f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3294f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3296f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3298f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x329af "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Controls I page
replace_tmln 0x32f6f "8b 77 8b 75 8b 29 2a 2b 2c 2d 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # dpad
replace_tmln 0x32f8f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32faf "8b 07 8b 75 8b 2e 2f 30 31 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # a
replace_tmln 0x32fcf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32fef "8b 08 8b 75 8b 32 33 30 31 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # b
replace_tmln 0x3300f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3302f "8b 0d 0a 0b 0a 09 0e 8b 75 8b 34 35 36 37 38 39 8b 8b 8b 8b" # select
replace_tmln 0x3304f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3306f "8b 0d 0e 07 0c 0e 8b 75 8b 3a 3b 3c 3d 8b 8b 8b 8b 8b 8b 8b" # start
## Controls II page
replace_tmln 0x3312f "8b 73 3e 3f 07 40 41 42 43 44 45 46 47 48 49 4a 8b 8b 8b 8b" # 1
replace_tmln 0x3314f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3316f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3318f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"

# English tokens
replace_tile 0x309cf "ea ea fa fa 2a 2a 6a 6a 2a 2a 6a 6a 6a 6a ff ff" #00 [fill]
replace_tile 0x309df "ef ef ff ff e8 e8 ea ea ea ea ea ea ea ea ff ff" #01 [ in]
replace_tile 0x309ef "ff ff ff ff e4 e4 ec ec e4 e4 ec ec e4 e4 ff ff" #02 [ em]
replace_tile 0x309ff "fd fd fd fd c4 c4 55 55 45 45 5d 5d 5c 5c ff ff" #03 [mpt]
replace_tile 0x30a0f "ff ff ff ff ae ae ae ae 8e 8e ee ee 8e 8e ff ff" #04 [y c]
replace_tile 0x30a1f "fa fa fa fa 4a 4a da da ca ca da da 4a 4a ff ff" #05 [ell]
replace_tile 0x30a2f "ff ff ff ff 9c 9c bc bc 9c 9c dc dc 9e 9e ff ff" #06 [s w]

replace_tile 0x30abf "d6 d6 f6 f6 52 52 56 56 56 56 56 56 52 52 ff ff" #0f [ith]
replace_tile 0x30acf "ff ff ff ff 3c 3c ba ba be be be be be be ff ff" #10 [h 1]
replace_tile 0x30adf "ff ff ff ff f1 f1 f5 f5 91 91 fd fd f1 f1 ff ff" #11 [-9 ]
replace_tile 0x30aef "ff ff ff ff c5 c5 d5 d5 d5 d5 d5 d5 d6 d6 ff ff" #12 [ nu]
replace_tile 0x30aff "ff ff ff ff 4c 4c 45 45 44 44 46 46 44 44 ff ff" #13 [ms]

replace_tile 0x30b0f "ff ff ff ff c5 c5 d5 d5 d5 d5 d5 d5 d6 d6 ff ff" #14 [ nu]
replace_tile 0x30b1f "ff ff ff ff 4f 4f 47 47 47 47 47 47 47 47 ff ff" #15 [um ]
replace_tile 0x30b2f "FF FF FF FF 24 24 6D 6D 64 64 6D 6D 65 65 FF FF" #16 [rep]
replace_tile 0x30b3f "FF FF FF FF 48 48 5A 5A 48 48 DA DA CA CA FF FF" #17 [pea]
replace_tile 0x30b4f "BF BF BF BF 93 93 B7 B7 B3 B3 BB BB 93 93 FF FF" #18 [ts ]
replace_tile 0x30b5f "BF BF FF FF A3 A3 AB AB AB AB AB AB AB AB FF FF" #19 [in ]
replace_tile 0x30b6f "FF FF FF FF 91 91 B5 B5 91 91 D5 D5 95 95 FF FF" #1a [sa]
replace_tile 0x30b7f "FF FF FF FF 33 33 17 17 13 13 17 17 13 13 FF FF" #1b [me ]
replace_tile 0x30b8f "FF FF FF FF 91 91 B5 B5 B5 B5 B5 B5 B1 B1 FF FF" #1c [ro]
replace_tile 0x30b9f "FF FF FF FF 1C 1C 1D 1D 1D 1D 1D 1D 94 94 F7 F7" #1d [w,c ]
replace_tile 0x30baf "FB FB FB FB 8B 8B AB AB AB AB AB AB 8B 8B FF FF" #1e [ol ]
replace_tile 0x30bbf "FF FF FF FF 89 89 AB AB AB AB AB AB 8B 8B FF FF" #1f [or]
replace_tile 0x30bcf "FF FF FF FF 3E 3E AB AB 36 36 AB AB 3E 3E FF FF" #20 [3x3]
replace_tile 0x30bdf "F7 F7 F7 F7 71 71 75 75 75 75 75 75 71 71 FF FF" #21 [3 b]
replace_tile 0x30bef "7F 7F 7F 7F 44 44 55 55 55 55 55 55 44 44 FF FF" #22 [loc]
replace_tile 0x30bff "BF BF BF BF AF AF AF AF 9F 9F AF AF AF AF FF FF" #23 [k ]

replace_tile 0x30c5f "ff ff ff ff 31 31 15 15 15 15 15 15 11 11 ff ff" #29 [mo]
replace_tile 0x30c6f "ff ff ff ff 53 53 57 57 53 53 57 57 b3 b3 ff ff" #2a [ve ]
replace_tile 0x30c7f "ff ff ff ff 95 95 b5 b5 b5 b5 b5 b5 99 99 ff ff" #2b [ cu]
replace_tile 0x30c8f "ff ff ff ff 24 24 6d 6d 65 65 75 75 64 64 ff ff" #2c [rso]
replace_tile 0x30c9f "ff ff ff ff 4f 4f 5f 5f 5f 5f 5f 5f 5f 5f ff ff" #2d [or]

replace_tile 0x30caf "fe fe fe fe 22 22 6a 6a 2a 2a 6a 6a 2a 2a ff ff" #2e [ent]
replace_tile 0x30cbf "ff ff ff ff 49 49 db db cb cb db db 4b 4b ff ff" #2f [ter]
replace_tile 0x30ccf "ff ff ff ff c5 c5 d5 d5 d5 d5 d5 d5 d6 d6 ff ff" #30 [ nu]
replace_tile 0x30cdf "ff ff ff ff 4f 4f 47 47 47 47 47 47 47 47 ff ff" #31 [um]
replace_tile 0x30cef "ff ff ff ff 24 24 6d 6d 2c 2c 6d 6d 2d 2d ff ff" #32 [era]
replace_tile 0x30cff "ff ff ff ff 49 49 5b 5b 49 49 6b 6b 49 49 ff ff" #33 [ase]
replace_tile 0x30d0f "77 77 7f 7f 14 14 55 55 55 55 55 55 54 54 ff ff" #34 [hig]
replace_tile 0x30d1f "dd dd dd dd 45 45 d5 d5 55 55 55 55 55 55 ff ff" #35 [ghl]
replace_tile 0x30d2f "7d 7d fd fd 44 44 5d 5d 55 55 55 55 45 45 ff ff" #36 [igh]
replace_tile 0x30d3f "df df df df 4e 4e 5e 5e 5e 5e 5e 5e 4e 4e ff ff" #37 [ht n]
replace_tile 0x30d4f "ff ff ff ff 2a 2a aa aa aa aa aa aa b2 b2 ff ff" #38 [num]
replace_tile 0x30d5f "ff ff ff ff 7f 7f 3f 3f 3f 3f 3f 3f 3f 3f ff ff" #39 [m]
replace_tile 0x30d6f "ff ff ff ff 11 11 55 55 51 51 57 57 17 17 ff ff" #3a [op]
replace_tile 0x30d7f "ff ff ff ff 23 23 6b 6b 2b 2b 6b 6b 2b 2b ff ff" #3b [en ]
replace_tile 0x30d8f "ff ff ff ff 32 32 16 16 12 12 16 16 12 12 ff ff" #3c [men]
replace_tile 0x30d9f "ff ff ff ff 2b 2b ab ab ab ab ab ab b3 b3 ff ff" #3d [nu]

replace_tile 0x30daf "fe fe fe fe 12 12 56 56 12 12 56 56 56 56 ff ff" #3e [aft]
replace_tile 0x30dbf "ff ff ff ff 49 49 db db cb cb db db 4b 4b ff ff" #3f [ter ]
replace_tile 0x30dcf "ff ff ff ff c4 c4 d5 d5 c5 c5 dd dd dd dd ff ff" #40 [ pr]
replace_tile 0x30ddf "ff ff ff ff 92 92 b6 b6 92 92 bb bb 92 92 ff ff" #41 [ess]
replace_tile 0x30def "ff ff ff ff 7b 7b f1 f1 7f 7f 71 71 7b 7b ff ff" #42 [s +]
replace_tile 0x30dff "df df df df c8 c8 da da da da da da c8 c8 ff ff" #43 [ to]
replace_tile 0x30e0f "ff ff ff ff e6 e6 e2 e2 e2 e2 e2 e2 e2 e2 ff ff" #44 [ ma]
replace_tile 0x30e1f "fd fd fd fd 25 25 ad ad 2c 2c ad ad ad ad ff ff" #45 [ark]
replace_tile 0x30e2f "ff ff ff ff 72 72 76 76 f6 f6 76 76 72 72 ff ff" #46 [k ca]
replace_tile 0x30e3f "ff ff ff ff 22 22 aa aa 2a 2a aa aa aa aa ff ff" #47 [and]
replace_tile 0x30e4f "ae ae be be 28 28 aa aa aa aa aa aa 28 28 ff ff" #48 [did]
replace_tile 0x30e5f "fb fb fb fb 89 89 ab ab 8b 8b ab ab a9 a9 ff ff" #49 [at]
replace_tile 0x30e6f "ff ff ff ff 27 27 6f 6f 27 27 77 77 27 27 ff ff" #4a [es]

# Slitherlink rules, controls and tips text
# Change tile map
## Rules
replace_tmln 0x32aef "8b 73 4b 4c 4d 4e 4f 50 51 52 53 54 55 8b 8b 8b 8b 8b 8b 8b" # 1
replace_tmln 0x32b0f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32b2f "8b 73 56 57 58 59 5a 5b 5c 5d 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # 2
replace_tmln 0x32b4f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32b6f "8b 73 84 5e 5f 60 61 62 63 64 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # 3
replace_tmln 0x32b8f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32baf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32bcf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32bef "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32c0f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32c2f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Controls
replace_tmln 0x3336f "8b 77 8b 75 8b 29 2a 2b 2c 2d 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b" # dpad
replace_tmln 0x3338f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x333af "8b 07 74 77 8b 75 8b 4b 4c 22 65 8b 8b 8b 8b 8b 8b 8b 8b 8b" # a + dpad
replace_tmln 0x333cf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x333ef "8b 08 74 77 8b 75 8b 4b 4c 66 67 8b 8b 8b 8b 8b 8b 8b 8b 8b" # b + dpad
replace_tmln 0x3340f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3342f "8b 0d 0e 07 0c 0e 8b 75 8b 3a 3b 3c 3d 8b 8b 8b 8b 8b 8b 8b" # start
## Tips
### Page I
replace_tmln 0x337ef "8b 73 68 69 6a 80 6b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3380f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3382f "8b 73 6c 6d 6e 6f 70 71 72 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3384f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3386f "8b 8b 75 8b f0 f2 f3 8b f5 f6 f3 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3388f "8b 8b 8b 8b f5 f4 f5 8b f5 f0 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x338af "8b 8b 8b 8b f5 f5 f5 8b f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x338cf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x338ef "8b 8b 75 8b f5 f7 f7 f3 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3390f "8b 8b 8b 8b f5 f5 f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3392f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
### Page II
replace_tmln 0x3398f "8b 8b 75 8b f5 f6 f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x339af "8b 8b 8b 8b f5 f5 f8 f3 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x339cf "8b 8b 8b 8b f5 f5 f4 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x339ef "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33a0f "8b 8b 75 8b f5 f4 f8 f3 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33a2f "8b 8b 8b 8b f5 f5 f4 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33a4f "8b 8b 73 8b 3a 24 25 26 27 28 c9 ed 9e a4 a5 ee 2f ef 93 8b"
replace_tmln 0x33a6f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33a8f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33aaf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33acf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
### Page III
replace_tmln 0x33b2f "8b 8b 8b 8b 8b fb 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33b4f "8b 8b 75 8b f5 fa fc 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33b6f "8b 8b 8b 8b f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33b8f "8b 8b 8b 8b f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33baf "8b 8b 75 8b f5 fd fe 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33bcf "8b 8b 8b 8b f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33bef "8b 8b 8b 8b f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33c0f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33c2f "8b 8b 75 8b f5 f5 f2 f3 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33c4f "8b 8b 8b 8b f5 f9 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33c6f "8b 8b 8b 8b f7 f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33c8f "8b 8b 8b 8b f4 f5 f5 f5 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"

replace_tile 0x30e7f "df df df df 12 12 56 56 56 56 56 56 16 16 ff ff" #4b [dra]
replace_tile 0x30e8f "ff ff ff ff 23 23 a3 a3 23 23 a3 a3 b3 b3 ff ff" #4c [aw ]
replace_tile 0x30e9f "ff ff ff ff ce ce ae ae ee ee ee ee ee ee ff ff" #4d [1 c]
replace_tile 0x30eaf "df df df df 51 51 d5 d5 d5 d5 d5 d5 51 51 ff ff" #4e [clo]
replace_tile 0x30ebf "ff ff ff ff 24 24 6d 6d 25 25 ad ad 24 24 ff ff" #4f [sed]
replace_tile 0x30ecf "77 77 77 77 74 74 75 75 75 75 75 75 74 74 ff ff" #50 [d lo]
replace_tile 0x30edf "ff ff ff ff 44 44 55 55 54 54 55 55 45 45 ff ff" #51 [oop]
replace_tile 0x30eef "ff ff ff ff 71 71 75 75 75 75 f5 f5 f1 f1 ff ff" #52 [p o]
replace_tile 0x30eff "ff ff ff ff 1c 1c 5d 5d 5d 5d 5d 5d 5c 5c ff ff" #53 [n g]
replace_tile 0x30f0f "fb fb ff ff 4a 4a da da 5a 5a 5a 5a 5a 5a ff ff" #54 [grid]
replace_tile 0x30f1f "bf bf bf bf 3f 3f bf bf bf bf bf bf 3f 3f ff ff" #55 [d]
replace_tile 0x30f2f "ff ff ff ff 15 15 55 55 55 55 55 55 59 59 ff ff" #56 [nu]
replace_tile 0x30f3f "ff ff ff ff 33 33 17 17 13 13 1b 1b 13 13 ff ff" #57 [ms ]
replace_tile 0x30f4f "ff ff ff ff fc fc 9d 9d fc fc 9e 9e fc fc ff ff" #58 [= s]
replace_tile 0x30f5f "bb bb fb fb a2 a2 aa aa aa aa aa aa a2 a2 ff ff" #59 [ide]
replace_tile 0x30f6f "fe fe ff ff 4e 4e de de 4e 4e ee ee 4e 4e ff ff" #5a [es i]
replace_tile 0x30f7f "fe fe fe fe 8e 8e ae ae ae ae ae ae ae ae ff ff" #5b [n l]
replace_tile 0x30f8f "ff ff ff ff 88 88 aa aa aa aa aa aa 88 88 ff ff" #5c [oo]
replace_tile 0x30f9f "ff ff ff ff 8f 8f af af 8f 8f bf bf bf bf ff ff" #5d [p ]
replace_tile 0x30faf "ff ff ff ff c9 c9 db db db db db db cb cb ff ff" #5e [ cr]
replace_tile 0x30fbf "ff ff ff ff 12 12 56 56 52 52 5b 5b 12 12 ff ff" #5f [oss]
replace_tile 0x30fcf "ff ff ff ff 71 71 f5 f5 75 75 75 75 71 71 ff ff" #60 [s o]
replace_tile 0x30fdf "fb fb fb fb 38 38 7a 7a 7a 7a 7a 7a 78 78 ff ff" #61 [r b]
replace_tile 0x30fef "ff ff ff ff 91 91 b5 b5 b1 b1 b5 b5 b5 b5 ff ff" #62 [ra]
replace_tile 0x30fff "fe fe fe fe 12 12 56 56 56 56 56 56 52 52 ff ff" #63 [nch]
replace_tile 0x3100f "ff ff ff ff 3f 3f bf bf bf bf bf bf bf bf ff ff" #64 [h ]

replace_tile 0x3101f "FF FF FF FF 47 47 57 57 47 47 5F 5F 5F 5F FF FF" #65 [op]
replace_tile 0x3102f "ff ff ff ff 89 89 bb bb ab ab ab ab 8b 8b ff ff" #66 [gr]
replace_tile 0x3103f "77 77 f7 f7 47 47 57 57 57 57 57 57 47 47 ff ff" #67 [id]

replace_tile 0x3104f "ef ef ef ef 24 24 6d 6d 2c 2c ad ad 25 25 ff ff" #68 [sta]
replace_tile 0x3105f "fb fb fb fb 49 49 5b 5b 5b 5b 5b 5b 59 59 ff ff" #69 [art]
replace_tile 0x3106f "fd fd ff ff c5 c5 c5 c5 c5 c5 c5 c5 e5 e5 ff ff" #6a [ wi]
replace_tile 0x3107f "ef ef d7 d7 d4 d4 c5 c5 d4 d4 d6 d6 ec ec ff ff" #6b [0s]
replace_tile 0x3108f "FF FF FF FF 22 22 6A 6A 6A 6A 6A 6A 22 22 FF FF" #6c [com]
replace_tile 0x3109f "FF FF FF FF 66 66 22 22 22 22 22 22 22 22 FF FF" #6d [mmo]
replace_tile 0x310af "FF FF FF FF 23 23 AB AB AB AB AB AB 2B 2B FF FF" #6e [on]
replace_tile 0x310bf "FF FF FF FF 88 88 AA AA 88 88 BA BA BA BA FF FF" #6f [pa]
replace_tile 0x310cf "B7 B7 B7 B7 92 92 B6 B6 B6 B6 B6 B6 92 92 FF FF" #70 [tte]
replace_tile 0x310df "FF FF FF FF 48 48 DA DA 5A 5A DA DA 5A 5A FF FF" #71 [ern]
replace_tile 0x310ef "FF FF FF FF 9F 9F B7 B7 9F 9F D7 D7 9F 9F FF FF" #72 [s:]
replace_tile 0x30c0f "FF FF FF FF 11 11 55 55 15 15 75 75 71 71 FF FF" #24 [po]
replace_tile 0x30c1f "EB EB FB FB 29 29 6B 6B 2B 2B AB AB 29 29 FF FF" #25 [sit]
replace_tile 0x30c2f "FF FF FF FF 1C 1C 5D 5D 1D 1D 7D 7D 1C 1C FF FF" #26 [e d]
replace_tile 0x30c3f "5F 5F 7F 7F 51 51 55 55 51 51 55 55 55 55 FF FF" #27 [dia]
replace_tile 0x30c4f "FF FF FF FF 11 11 75 75 55 55 55 55 11 11 FF FF" #28 [go]
replace_tile 0x3165f "FF FF FF FF 11 11 55 55 51 51 55 55 55 55 FF FF" #c9 [na]
replace_tile 0x3189f "77 77 7F 7F 74 74 75 75 74 74 76 76 74 74 FF FF" #ed [l is]
replace_tile 0x318af "DE DE DE DE 12 12 56 56 52 52 56 56 12 12 FF FF" #ee [det]
replace_tile 0x318bf "F7 F7 FF FF 34 34 15 15 15 15 15 15 15 15 FF FF" #ef [min]
replace_tile 0x312ff "FE FE FE FE 48 48 5A 5A 4A 4A 5A 5A 48 48 FF FF" #93 [ned]

# Nonogram rules, controls and tips text
# Change tile map
## Rules
replace_tmln 0x32d2f "8b 73 00 02 03 04 05 d2 d3 d4 d5 e2 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32d4f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32d6f "8b 73 56 57 e3 e4 e5 d8 db dc 22 b1 01 b2 b3 b4 b5 8b 8b 8b"
replace_tmln 0x32d8f "8b 8b b6 b7 1e 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32daf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32dcf "8b 73 b9 02 03 04 05 96 97 98 64 00 c1 c2 c3 c4 8b 8b 8b 8b"
replace_tmln 0x32def "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32e0f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32e2f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32e4f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x32e6f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Controls
replace_tmln 0x335af "8b 77 8b 75 8b 29 2a 2b 2c 2d 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x335cf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x335ef "8b 07 8b 75 8b 00 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3360f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3362f "8b 08 8b 75 8b 94 95 76 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3364f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3366f "8b 0d 0e 07 0c 0e 8b 75 8b 3a 3b 3c 3d 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x3368f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
## Tips
replace_tmln 0x33d8f "8b 73 c5 c6 c7 c8 de 05 df 9d 9e a4 a5 00 c1 8b 8b 8b 8b 8b"
replace_tmln 0x33daf "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33dcf "8b 73 94 95 76 02 03 04 05 a6 a7 a8 ad ae 1c 1d 1e 8b 8b 8b"
replace_tmln 0x33dcf "8b 73 94 95 76 02 03 04 05 a6 a7 a8 ad ae b4 b5 b6 b7 1e 8b"
replace_tmln 0x33def "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33e0f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33e2f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33e4f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33e6f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"
replace_tmln 0x33e8f "8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b 8b"

replace_tile 0x316ef "FD FD FD FD 9C 9C BD BD 9D 9D DD DD 9C 9C FF FF" #D2 [s t]
replace_tile 0x316ff "FF FF FF FF 8E 8E AE AE AE AE AE AE 8E 8E FF FF" #D3 [o f]
replace_tile 0x3170f "FF FF FF FF 44 44 D5 D5 55 55 D5 D5 C5 C5 FF FF" #D4 [for]
replace_tile 0x3171f "FF FF FF FF 9E 9E 8E 8E 8E 8E 8E 8E 8E 8E FF FF" #D5 [m p]
replace_tile 0x317ef "EF EF FF FF 29 29 AB AB 2B 2B EB EB E9 E9 FF FF" #E2 [pic]
replace_tile 0x317ff "FD FD FD FD FD FD 9D 9D FD FD 9D 9D FD FD FF FF" #E3 [= l]
replace_tile 0x3180f "FF FF FF FF 23 23 6B 6B 2B 2B 6B 6B 2B 2B FF FF" #E4 [en ]
replace_tile 0x3181f "FF FF FF FF 89 89 AB AB A9 A9 AB AB 8B 8B FF FF" #E5 [of]

replace_tile 0x3174f "FA FA FE FE CA CA DA DA CA CA DA DA DA DA FF FF" #D8 [ fil]
replace_tile 0x3177f "BF BF BF BF A4 A4 AD AD A5 A5 AD AD A4 A4 FF FF" #DB [led]
replace_tile 0x3178f "77 77 77 77 71 71 75 75 75 75 75 75 71 71 FF FF" #DC [d b]

replace_tile 0x314df "BF BF BF BF A9 A9 AB AB 99 99 AD AD A9 A9 FF FF" #B1 [ks]
replace_tile 0x314ef "FF FF FF FF E4 E4 ED ED E4 E4 ED ED E5 E5 FF FF" #B2 [ ea]
replace_tile 0x314ff "FB FB FB FB 48 48 5A 5A 5A 5A 5A 5A 4A 4A FF FF" #B3 [ach]
replace_tile 0x3150f "FF FF FF FF E4 E4 ED ED ED ED ED ED EC EC FF FF" #B4 [ ro]
replace_tile 0x3151f "FF FF FF FF 47 47 47 47 47 47 47 47 67 67 FF FF" #B5 [ow ]
replace_tile 0x3152f "FF FF FF FF 11 11 55 55 15 15 55 55 55 55 FF FF" #B6 [an]
replace_tile 0x3153f "DF DF DF DF 1C 1C 5D 5D 5D 5D 5D 5D 1C 1C FF FF" #B7 [d c]
replace_tile 0x3155f "FF FF FF FF 9F 9F 5B 5B D1 D1 DB DB DF DF FF FF" #B9 [1+]

replace_tile 0x315df "FD FD FD FD 91 91 B5 B5 95 95 B5 B5 91 91 FF FF" #C1 [ed]
replace_tile 0x315ef "DD DD DD DD C5 C5 D5 D5 D5 D5 D5 D5 C5 C5 FF FF" #C2 [ bl]
replace_tile 0x315ff "FE FE FE FE 12 12 56 56 56 56 56 56 12 12 FF FF" #C3 [ock]
replace_tile 0x3160f "FF FF FF FF A7 A7 AF AF 67 67 B7 B7 A7 A7 FF FF" #C4 [ks ]

replace_tile 0x3161f "FF FF FF FF 15 15 55 55 55 55 55 55 19 19 FF FF" #C5 [ov]
replace_tile 0x3162f "FD FD FD FD 25 25 6D 6D 2D 2D 6D 6D 2D 2D FF FF" #C6 [erl]
replace_tile 0x3163f "FF FF FF FF 11 11 55 55 11 11 57 57 57 57 FF FF" #C7 [ap]
replace_tile 0x3164f "F7 F7 FF FF 14 14 55 55 15 15 75 75 75 75 FF FF" #C8 [pin]
replace_tile 0x317af "FF FF FF FF 46 46 5E 5E 56 56 56 56 46 46 FF FF" #DE [ng c]
replace_tile 0x317bf "FF FF FF FF 9C 9C BD BD 9C 9C DD DD 9D 9D FF FF" #DF [s a]
replace_tile 0x3139f "FF FF FF FF 49 49 5B 5B 59 59 5B 5B 59 59 FF FF" #9D [are]
replace_tile 0x313af "FD FD FD FD C5 C5 D5 D5 C5 C5 D5 D5 D5 D5 FF FF" #9E [ al]
replace_tile 0x3140f "FF FF FF FF 11 11 15 15 11 11 15 15 95 95 FF FF" #A4 [wa]
replace_tile 0x3141f "FF FF FF FF 53 53 57 57 13 13 DB DB 13 13 FF FF" #A5 [ys ]

replace_tile 0x3142f "FD FD FF FF 9D 9D BD BD 9D 9D DD DD 9D 9D FF FF" #A6 [s i]
replace_tile 0x3143f "FF FF FF FF 1C 1C 5D 5D 5C 5C 5D 5D 5D 5D FF FF" #A7 [n f]
replace_tile 0x3144f "BE BE FF FF A2 A2 AA AA AA AA AA AA AA AA FF FF" #A8 [ini]
replace_tile 0x3149f "F7 F7 F7 F7 91 91 B5 B5 95 95 D5 D5 95 95 FF FF" #AD [sh]
replace_tile 0x314af "FB FB FB FB 23 23 6B 6B 2B 2B 6B 6B 23 23 FF FF" #AE [ed]

replace_tile 0x3110f "ff ff ef ef ef ef 83 83 ef ef ef ef ff ff ff ff" #74 [+]
replace_tile 0x3118f "ff ff ff ff 15 15 75 75 15 15 d5 d5 19 19 ff ff" #7c [su]
replace_tile 0x3119f "df df df df 11 11 55 55 55 55 55 55 11 11 ff ff" #7d [do]
replace_tile 0x311af "ff ff ff ff 55 55 55 55 35 35 55 55 59 59 ff ff" #7e [ku]
replace_tile 0x311bf "f5 f5 f7 f7 15 15 75 75 15 15 d5 d5 15 15 ff ff" #7f [sli]
replace_tile 0x311cf "b7 b7 b7 b7 11 11 b5 b5 b5 b5 b5 b5 95 95 ff ff" #80 [th]
replace_tile 0x311df "ff ff ff ff 11 11 57 57 17 17 77 77 17 17 ff ff" #81 [er]
replace_tile 0x311ef "5f 5f 7f 7f 51 51 55 55 55 55 55 55 55 55 ff ff" #82 [lin]
replace_tile 0x311ff "ff ff ff ff 5f 5f 5f 5f 3f 3f 5f 5f 5f 5f ff ff" #83 [k ]
replace_tile 0x3120f "ff ff ff ff 11 11 55 55 55 55 55 55 51 51 ff ff" #84 [no]
replace_tile 0x3121f "ff ff ff ff 11 11 77 77 57 57 57 57 17 17 ff ff" #85 [gr]
replace_tile 0x3122f "ff ff ff ff 10 10 55 55 15 15 55 55 55 55 ff ff" #86 [am]
replace_tile 0x3123f "ff ff ff ff 7f 7f 7f 7f 7f 7f 7f 7f 7f 7f ff ff" #87 [m ]
replace_tile 0x3124f "7f 7f 7f 7f 11 11 55 55 55 55 55 55 51 51 ff ff" #88 [ho]
replace_tile 0x3125f "ff ff ff ff 57 57 57 57 57 57 57 57 07 07 ff ff" #89 [w ]
replace_tile 0x3126f "bf bf bf bf 11 11 b5 b5 b5 b5 b5 b5 91 91 ff ff" #8a [to]

replace_tile 0x3130f "FF FF FF FF 31 31 15 15 11 11 15 15 15 15 FF FF" #94 [ma]
replace_tile 0x3131f "ef ef ef ef 2b 2b 6b 6b 67 67 6b 6b 6b 6b ff ff" #95 [rk]
replace_tile 0x3132f "EF EF EF EF E2 E2 EA EA EA EA EA EA E2 E2 FF FF" #96 [ be]
replace_tile 0x3133f "DF DF DF DF 48 48 D8 D8 58 58 D8 D8 4C 4C FF FF" #97 [etw]
replace_tile 0x3134f "FF FF FF FF 92 92 B6 B6 92 92 B6 B6 92 92 FF FF" #98 [een]

replace_tile 0x3154f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #B8 []

## Freed for english alphabet tokens
replace_tile 0x3075f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #49
replace_tile 0x3077f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #4b
replace_tile 0x3078f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #4c
replace_tile 0x3079f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #3d
replace_tile 0x307af "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #4e
replace_tile 0x307df "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #51
replace_tile 0x307ef "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #52
replace_tile 0x307ff "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #53
replace_tile 0x3080f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #54
replace_tile 0x3087f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #5b
replace_tile 0x3088f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #5c
replace_tile 0x3089f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #5d
replace_tile 0x308af "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #5e
replace_tile 0x308ff "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #63
replace_tile 0x3091f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #65
replace_tile 0x3095f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #69
replace_tile 0x3097f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #6b
replace_tile 0x3098f "3f 3f 60 60 2a 2a 6a 6a 2a 2a ff ff ff ff ff ff" #6c


# Banners in level selection:
## Sudoku
replace_tmln 0x14ee8 "03 03 03 03 03 09 0b 0d 0f 11 13 15 17 19 03 03 03 03 03 03"
replace_tmln 0x14f08 "03 03 03 03 03 20 22 24 26 28 2a 2c 2e 1b 03 03 03 03 03 48"
replace_tmln 0x14f28 "03 03 03 03 03 21 23 25 27 29 2b 2d 2f 1d 03 03 03 03 48 5c"

replace_tile 0x142b8 "FF FF FF FF FF FF FF FF FF FF FE FF FC FE FC FC" #0f
replace_tile 0x142d8 "FF FF FF FF FF FF FF FF FF FF FF 00 00 00 00 00" #11
replace_tile 0x142f8 "FF FF FF FF FF F8 E0 F0 A3 C1 83 01 03 01 01 03" #13
replace_tile 0x14318 "FF FF FF FF 1F 38 00 10 01 00 81 01 81 01 81 01" #15
replace_tile 0x14338 "FF FF FF FF 9F 1F 0F 07 87 83 83 81 80 80 B0 80" #17
replace_tile 0x14358 "FF FF FF FF FF FF FF FF FF FF FF FF 3F 0F 0F 07" #19

replace_tile 0x14428 "F8 FC F8 F8 F8 F8 59 38 19 98 F9 78 F8 F0 F8 F0" #26
replace_tile 0x14448 "F6 60 FE F6 CE F6 C6 86 E6 C4 F6 E4 7C F6 3C 76" #28
replace_tile 0x14468 "67 CF EF CF FB D9 FB DB F3 DB F3 DB F3 DB FB D3" #2a
replace_tile 0x14488 "B1 19 BD 39 EF 6D EF 65 C7 6D E7 4D EF 45 CF 6D" #2c
replace_tile 0x144a8 "F6 B0 B6 EE E6 EE EE C6 EC C6 CC C6 CE E4 6E E4" #2e
replace_tile 0x14378 "67 C3 E7 C3 E7 C3 E7 C3 E7 C3 E3 C7 E7 C7 EF C7" #1b

replace_tile 0x14438 "F8 F0 F9 F0 F8 F1 FB F1 F9 F0 F8 F0 FC F8 FF FC" #27
replace_tile 0x14458 "FC 36 F7 E7 F7 E7 FF FF FF 00 00 00 00 00 FF 00" #29
replace_tile 0x14478 "FB D3 DF 9F DF 9F FF FF FF 00 00 00 00 00 FF 00" #2b
replace_tile 0x14498 "FD 7F FD 7B BD 7B FF FF FF 00 00 00 00 00 FF 00" #2d
replace_tile 0x144b8 "6C F6 6F B7 6F B7 FF FF FF 00 00 00 00 00 FF 00" #2f
replace_tile 0x14398 "EF C7 CF 87 CF 87 C7 C7 C7 07 07 07 0F 07 FF 0F" #1d

## Slitherlink
replace_tmln 0x15d28 "05 11 03 03 26 28 2a 2c 2e 30 32 34 36 38 3a 03 03 15 93 07"
replace_tmln 0x15d48 "05 11 03 03 27 29 2b 2d 2f 31 33 35 37 39 3b 03 03 15 93 07"
replace_tmln 0x15d68 "05 11 03 03 44 46 48 4a 4c 4e 50 52 54 56 58 03 03 15 93 07"

replace_tmln 0x15f68 "05 11 03 03 26 28 2a 2c 2e 30 32 34 36 38 3a 03 03 15 93 07"
replace_tmln 0x15f88 "05 11 03 03 27 29 2b 2d 2f 31 33 35 37 39 3b 03 03 15 93 07"
replace_tmln 0x15fa8 "05 11 03 03 44 46 48 4a 4c 4e 50 52 54 56 58 03 03 1b 1d 07"

replace_tile 0x153c8 "FF FF FF FF FF FF FF FF FF FF FD FE F8 FC F8 F8" #2c
replace_tile 0x153d8 "F1 F8 F1 F1 F3 F1 F3 F1 F3 F1 F3 F1 F0 E1 F0 E0" #2d
replace_tile 0x153e8 "FF FF FF FF FF FF E1 E1 CC C4 8C 0C 0D 0C 0D 0D" #2e
replace_tile 0x153f8 "EE CC FF ED 9F ED 8F 0D CF 8D EB CD FB ED 7B ED" #2f
replace_tile 0x15408 "FF FF FF FF FF FF E0 E0 43 81 03 03 93 B3 F3 B3" #30
replace_tile 0x15418 "7F 3B FF BB FB B3 FB B3 FB B3 FA B3 FA B3 FA B3" #31
replace_tile 0x15428 "FF FF FF FF FF FF 3F 1F 17 0F 03 07 00 00 00 80" #32
replace_tile 0x15438 "E3 C2 F7 E7 7F 6D 3D 6F 39 6D 7F 6F 7F 6E 7A 6C" #33
replace_tile 0x15448 "FF FF FF FF FF FE F8 E0 E1 80 81 01 01 01 01 01" #34
replace_tile 0x15458 "1D 39 BF 3D FB BD FB B1 FB B1 AB 31 2B 31 2B 31" #35
replace_tile 0x15468 "FF FF FF FF 1F 0F 0F 0E 86 86 82 84 B0 90 B8 B0" #36
replace_tile 0x15478 "C9 87 FF B7 FE B6 FE B6 FE B6 7E B6 FC 36 7E B4" #37
replace_tile 0x15488 "FF FF FF FF FF 03 03 01 18 08 18 18 18 18 1B 18" #38
replace_tile 0x15498 "DF 9B FA DE FE DE 7E DC 7E DC FC DC FC DE F6 DE" #39
replace_tile 0x154a8 "FF FF FF FF FF FF FF FF 7F 7F 3F 3F 3F 3F 3F 3F" #3a
replace_tile 0x154b8 "3F 3F 3F 3F 7F 3F 7F 7F 7F 7F 7F 7F 3F 1F 1F 0F" #3b
#replace_tile 0x154c8 "" #3c
#replace_tile 0x154d8 "" #3d
#replace_tile 0x154e8 "" #3e
#replace_tile 0x154f8 "" #3f
#replace_tile 0x15508 "" #40
#replace_tile 0x15518 "" #41
#replace_tile 0x15528 "" #42
#replace_tile 0x15538 "" #43
replace_tile 0x155a8 "F1 E0 F3 E1 F1 E3 F3 E7 F7 E0 F0 E0 F8 F0 F8 FF" #4a
replace_tile 0x155c8 "FB 6D EF CD EF CD FF FF FF 00 00 00 00 00 00 FF" #4c
replace_tile 0x155e8 "EB B2 7F BA 7E BB FF FF FF 00 00 00 00 00 00 FF" #4e
replace_tile 0x15608 "7A 6C 6F 6F 6F 6F FF FF FF 00 00 00 00 00 00 FF" #50
replace_tile 0x15628 "2B 31 AB 31 AB 31 FF FF FF 00 00 00 00 00 00 FF" #52
replace_tile 0x15648 "7E B4 EC B6 EC B6 FF FF FF 00 00 00 00 00 00 FF" #54
replace_tile 0x15668 "F6 DE F6 DA F6 DA FF FF FF 00 00 00 00 00 00 FF" #56
replace_tile 0x15688 "1F 0F 1F 0F 1F 0F 1F 8F 9F 0F 1F 0F 3F 1F 3F FF" #58
#replace_tile 0x156a8 "" #5a
#replace_tile 0x156c8 "" #5c
#replace_tile 0x156e8 "" #5e

## Nonogram
replace_tmln 0x16d58 "07 07 07 07 20 22 24 26 28 2a 2c 2e 30 32 34 07 07 07 07 07"
replace_tmln 0x16d78 "09 09 09 09 21 23 25 27 29 2b 2d 2f 31 33 35 09 09 09 09 09"
replace_tmln 0x16d98 "0b 0b 0b 0b 0d 40 42 44 46 48 4a 4c 4e 50 52 0b 0b 0b 0b 0b"

replace_tmln 0x16f98 "07 07 07 07 20 22 24 26 28 2a 2c 2e 30 32 34 07 07 07 07 07"
replace_tmln 0x16fb8 "09 09 09 09 21 23 25 27 29 2b 2d 2f 31 33 35 09 09 09 09 09"
replace_tmln 0x16fd8 "0b 0b 0b 0b 0d 40 42 44 46 48 4a 4c 4e 50 52 0b 0b 0b 0b 0b"

replace_tile 0x16408 "FF FF FF FF 55 FF AA FF 55 FE FE FC FC F8 FC F8" #26
replace_tile 0x16418 "54 F8 AC F8 FC F8 5C 38 1C 98 D0 78 F8 F8 F0 E0" #27
replace_tile 0x16428 "FF FF FF FF 55 FF FF 00 00 00 00 00 38 F0 FD F9" #28
replace_tile 0x16438 "DF FB CF DB CE DB 9F DA DF 9A DE 9B DE 9B 9F DB" #29
replace_tile 0x16448 "FF FF FF FF 55 FF FF 00 00 00 00 00 83 CF EF CF" #2a
replace_tile 0x16458 "7D 6F 7C 2D 3C 6D 39 6D 7D 29 7D 69 6D 79 E9 DD" #2b
replace_tile 0x16468 "FF FF FF FF 55 FF FF 00 00 00 00 00 88 0C DE 9C" #2c
replace_tile 0x16478 "F7 B6 F7 B2 E3 B6 F3 A6 F7 A2 E7 B6 E7 B6 FF BC" #2d
replace_tile 0x16488 "FF FF FF FF 55 FF C0 00 00 00 00 00 39 73 7B FB" #2e
replace_tile 0x16498 "EB DB C3 C3 83 C3 DA 83 9E DB 9A DF BA DF FE FB" #2f
replace_tile 0x164a8 "FF FF FF FF 55 FF 00 00 00 00 00 00 C6 82 DF CF" #30
replace_tile 0x164b8 "BF DB BF 1B B3 1B B3 1B BB 13 9B 33 96 3A 9F 3F" #31
replace_tile 0x164c8 "FF FF FF FF 55 FF 00 00 00 00 00 00 1B 3B 7F 7F" #32
replace_tile 0x164d8 "FF 6D FF 6D FF 6D CF 6D CF 6D CF 6D EF 4D E9 4D" #33
replace_tile 0x164e8 "FF FF FF FF 55 FF 2A 7F 15 1F 1F 0F 0F 07 8F 87" #34
replace_tile 0x164f8 "CD 87 CA 87 8F C7 87 C7 87 C7 C5 83 C3 81 C3 81" #35
#replace_tile 0x16508 "" #36
#replace_tile 0x16518 "" #37
#replace_tile 0x16528 "" #38
#replace_tile 0x16538 "" #39
#replace_tile 0x16548 "" #3a
#replace_tile 0x16558 "" #3b
#replace_tile 0x16568 "" #3c
#replace_tile 0x16578 "" #3d
#replace_tile 0x16588 "" #3e
#replace_tile 0x16598 "" #3f
replace_tile 0x165e8 "F0 E0 F1 E3 F3 E0 50 E0 F8 F0 F8 FF FF FF FF FF" #44
replace_tile 0x16608 "9D DB FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #46
replace_tile 0x16628 "E9 DD FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #48
replace_tile 0x16648 "DF BC FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #4a
replace_tile 0x16668 "7E FB FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #4c
replace_tile 0x16688 "9F 3F FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #4e
replace_tile 0x166a8 "C9 6D FF FF FF 00 00 00 00 00 00 FF FF FF FF FF" #50
replace_tile 0x166c8 "C3 81 E3 F1 F3 01 03 01 07 03 07 FF FF FF FF FF" #52
#replace_tile 0x16658 "" #4b
#replace_tile 0x16678 "" #4d
#replace_tile 0x16698 "" #4f
#replace_tile 0x166b8 "" #51
#replace_tile 0x166d8 "" #53

# Clear screens
## Sudoku
replace_tmln 0x10ed2 "05 09 09 09 09 0a 0c 8a 8c 8e 90 92 09 9b 9d 9f 9e 10 09 08"
replace_tmln 0x10ef2 "05 09 09 09 09 0b 0d 8b 8d 8f 91 93 9a 9c 09 09 09 11 09 08"
replace_tmln 0x10f12 "05 09 09 09 09 0e 0f 94 95 96 97 98 99 09 09 09 09 12 09 08"

replace_tile 0x10aa2 "FF FF FF FF FF FF FF FF FE 3F 7E 3C F8 7C 7D F8" #8a
replace_tile 0x10ab2 "FD F9 B9 79 3B 19 5B 89 39 18 B8 70 E3 F1 75 E3" #8b
replace_tile 0x10ac2 "FF FF FF FF FF FF FF FF FF 00 00 00 00 00 93 D6" #8c
replace_tile 0x10ad2 "F3 D6 B7 D6 97 16 D7 96 F7 D6 F7 56 F7 D6 9C FF" #8d
replace_tile 0x10ae2 "FF FF FF FF DB E7 41 83 10 10 38 10 18 30 7B F3" #8e
replace_tile 0x10af2 "DF F7 9D B4 BD B4 BC B5 BC B5 BD B4 BD B7 F7 FF" #8f
replace_tile 0x10b02 "FF FF FF FF BF C7 83 00 20 20 20 20 2C 20 BD 2D" #90
replace_tile 0x10b12 "ED BB F9 BB FB B1 F3 B1 FB B9 BB ED BB ED 2D FF" #91
replace_tile 0x10b22 "FF FF FF FF FF FF DF 3F 0F 1F 0F 07 07 03 31 63" #92
replace_tile 0x10b32 "31 63 71 63 77 63 77 63 77 63 77 63 73 63 CB F1" #93
replace_tile 0x10b42 "73 E7 F0 60 6F 30 F0 FF FF FF FF FF FF FF FF FF" #94
replace_tile 0x10b52 "FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF FF FF" #95
replace_tile 0x10b62 "FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF FF FF" #96
replace_tile 0x10b72 "FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF FF FF" #97
replace_tile 0x10b82 "F3 F9 02 01 FD 02 02 FD FD FB F3 FF EF F7 D7 EF" #98

#replace_tile 0x10ba2 "ff ff ff ff fd fe fa fd f7 fb ef f7 df ef bf df" #9a
#replace_tile 0x10b92 "7f bf ff 7f 7f ff ff ff ff ff ff ff ff ff ff ff" #99

## Slitherlink
replace_tmln 0x2f6a0 "05 09 09 09 09 0a 0c 4e 50 52 54 56 58 5a 5c 5e 60 10 09 08"
replace_tmln 0x2f6c0 "05 09 09 09 09 0b 0d 4f 51 53 55 57 59 5b 5d 09 09 11 09 08"
replace_tmln 0x2f6e0 "05 09 09 09 09 0e 0f 4d 62 63 64 65 66 67 68 09 09 12 09 08"

replace_tile 0x2f090 "79 F0 FA 71 79 33 F8 F0 F7 F8 F8 FF FF FF FF FF" #4d
replace_tile 0x2f0a0 "FF FF FF FF FF FF FF FF FE 3F 7C 3E FC 7C 78 FC" #4e
replace_tile 0x2f0b0 "F8 F8 B9 78 39 18 59 88 39 18 B8 70 F8 F0 78 F0" #4f
replace_tile 0x2f0c0 "FF FF FF FF F0 F0 E6 E2 C6 06 06 06 06 06 F7 66" #50
replace_tile 0x2f0d0 "FF F6 CF F6 C7 86 E7 C6 F5 E6 7D F6 3D 76 FD 36" #51
replace_tile 0x2f0e0 "FF FF FF FF E0 E0 21 40 01 01 C9 59 F9 D9 3F 1D" #52
replace_tile 0x2f0f0 "FF DD FD D9 FD D9 FD D9 FD D9 FD D9 FD D9 F5 D9" #53
replace_tile 0x2f100 "FF FF FF FF 1F 0F 8B 87 81 83 80 80 80 C0 F1 E1" #54
replace_tile 0x2f110 "FB F3 BF B6 9E B7 9C B6 3F B7 3F B7 3D B6 BD 36" #55
replace_tile 0x2f120 "FF FF FF FF FC F0 F0 C0 C0 80 00 00 00 00 8E 1C" #56
replace_tile 0x2f130 "DF 9E FD DE FD D8 FD D8 D5 98 95 18 15 18 15 18" #57
replace_tile 0x2f140 "FF FF 8F 07 07 07 C3 43 C1 C2 D8 C8 DC D8 E4 C3" #58
replace_tile 0x2f150 "FF DB FF DB FF DB FF DB BE DB FF 9A BF DA BF DA" #59
replace_tile 0x2f160 "FF FF FF 81 81 00 0C 04 0C 0C 0C 0C 0D 0C EF CD" #5a
replace_tile 0x2f170 "FD EF 7F 6F 3F 6E 3F 6E 7E 6E 7E 6F 7B 6F 7B 6F" #5b
replace_tile 0x2f180 "FF FF FF FF FB FC 18 27 17 0F 1F 1F 9F 1F 9F 9F" #5c
replace_tile 0x2f190 "1F 1F 3F 1F 3F 3F 3F 3F 3F 3F 1F 0F 0F 07 0F 07" #5d
replace_tile 0x2f1a0 "FF FF B4 CB 44 BF FF FF FF FF FF FF FF FF FF FF" #5e
#replace_tile 0x2f1b0 "" #5f
replace_tile 0x2f1c0 "FF FF DF 3F 3D C3 E3 FC FC FF FF FF FF FF FF FF" #60
#replace_tile 0x2f1d0 "" #61
replace_tile 0x2f1e0 "F7 E6 E6 FF FF FF 00 00 FF 00 00 FF FF FF FF FF" #62
replace_tile 0x2f1f0 "BF DD 9D FF FF FF 00 00 FF 00 00 FF FF FF FF FF" #63
replace_tile 0x2f200 "B7 37 37 FF FF FF 00 00 FF 00 00 FF FF FF FF FF" #64
replace_tile 0x2f210 "D5 98 90 FF FF FF 00 00 FF 00 00 FF EF F7 D7 EF" #65
replace_tile 0x2f220 "F6 DB D2 FF FF FF 00 00 FF 00 00 FF FF FF FF FF" #66
replace_tile 0x2f230 "7B 6D 69 FF FF FF 00 00 FF 00 00 FF FF FF FF FF" #67
replace_tile 0x2f240 "0F 07 4F 87 8F C7 0F 07 F7 0F 0F FF FF FF FF FF" #68
#replace_tile 0x2f250 "" #69
#replace_tile 0x2f270 "" #6b

## Nonogram
replace_tmln 0x1a1b0 "05 09 09 09 09 0a 0c 4e 50 52 54 56 58 5a 5c 5e 60 10 09 08"
replace_tmln 0x1a1d0 "05 09 09 09 09 0b 0d 4f 51 53 55 57 59 5b 5d 09 09 11 09 08"
replace_tmln 0x1a1f0 "05 09 09 09 09 0e 0f 62 64 66 68 6a 6c 6e 70 09 09 12 09 08"

replace_tile 0x19ba0 "FF FF FF FF FF FF FF FF FF 3E 7E 3C FC 78 7C F8" #4e
replace_tile 0x19bb0 "FC F8 BC 78 3C 18 5C 88 3C 18 B8 78 F8 F8 78 F0" #4f
replace_tile 0x19bc0 "FF FF FF FF FF FF FF 00 00 00 00 00 38 F0 FD F9" #50
replace_tile 0x19bd0 "DF FB CF DB CE DB 9F DA 9F DA DE 9B DE 9B DF 9B" #51
replace_tile 0x19be0 "FF FF FF FF FF FF FF 00 00 00 00 00 83 CF EF CF" #52
replace_tile 0x19bf0 "7D 6F 7C 2D 3C 6D 39 6D 79 2D 79 6D 6D 79 ED D9" #53
replace_tile 0x19c00 "FF FF FF FF FF FF FF 00 00 00 00 00 88 0C DE 9C" #54
replace_tile 0x19c10 "F7 B6 F7 B2 E3 B6 F3 A6 F7 A2 E7 B6 E7 B6 FF BC" #55
replace_tile 0x19c20 "FF FF FF FF FF FF C0 00 00 00 00 00 39 73 7B FB" #56
replace_tile 0x19c30 "EB DB C3 C3 83 C3 DA 83 9E DB 9A DF BA DF FE FB" #57
replace_tile 0x19c40 "FF FF FF FF FF FF 00 00 00 00 00 00 C6 82 DF CF" #58
replace_tile 0x19c50 "BF DB BF 1B B3 1B B3 1B BB 13 9B 33 96 3A 9F 3F" #59
replace_tile 0x19c60 "FF FF FF FF FF FF 00 00 00 00 00 00 1B 3B 7F 7F" #5a
replace_tile 0x19c70 "FF 6D FF 6D FF 6D CF 6D CF 6D CF 6D EF 4D E9 4D" #5b
replace_tile 0x19c80 "FF FF FF FF FB FC 18 67 07 1F 1F 0F 0F 07 8F 87" #5c
replace_tile 0x19c90 "CF 87 CF 87 8F C7 87 C7 87 C7 C7 87 C7 83 C7 83" #5d
replace_tile 0x19ca0 "FF FF B4 CB 44 BF FF FF FF FF FF FF FF FF FF FF" #5e
#replace_tile 0x19cb0 "" #5f
replace_tile 0x19cc0 "FF FF DF 3F 3D C3 E3 FC FC FF FF FF FF FF FF FF" #60
#replace_tile 0x19cd0 "" #61

replace_tile 0x19ce0 "78 F3 F9 73 78 30 F7 F8 F8 FF FF FF FF FF FF FF" #62
replace_tile 0x19d00 "99 FF FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF" #64
replace_tile 0x19d20 "C9 FF FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF" #66
replace_tile 0x19d40 "9C FF FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF" #68
replace_tile 0x19d60 "7A FF FF FF 00 00 FF 00 00 FF F5 FB EB F7 D7 EF" #6a
replace_tile 0x19d80 "1F FF FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF" #6c
replace_tile 0x19da0 "C9 7F FF FF 00 00 FF 00 00 FF FF FF FF FF FF FF" #6e
replace_tile 0x19dc0 "87 F3 E7 F3 07 03 FB 07 07 FF FF FF FF FF FF FF" #70
#replace_tile 0x19de0 "" #72
#replace_tile 0x19e00 "" #74

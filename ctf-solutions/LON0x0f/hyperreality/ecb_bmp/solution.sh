#!/bin/bash

# Inspecting the image in a hex editor, we see that the first few bytes start "Salted__". This turns out to be an OpenSSL header format in which the next 8 bytes represent the salt.

# Reconstructing this image involves knowing its dimensions. Wikipedia notes the following formula:

# number of pixels * bitdepth / 8 = bitmap size in bytes

# This isn't an exact science here as there is extra header information added to the bitmap including the salt. But if we backtrack from the known size of the image, 307360 * 8 / 32, we get 76840. The next step was a bit of guesswork and required a hint from the challenge setter, but the dimensions turn out to be 320 * 240.

echo -n Width x Height of image is approximately: 
echo '307360 * 8 / 32' | bc

# Now if we simply create a blank bitmap of the correct dimensions, and use its the header for the encrypted data, we should be able to see the answer!

# Why does this work? Because ECB operates in blocks of 16 bytes and the same block will always encrypt the same way. So although the colours will be different the data will still be visible. See: https://crypto.stackexchange.com/questions/14487/can-someone-explain-the-ecb-penguin

xxd blank.bmp | head -n8 | xxd -r >> out.bmp
tail -c +17 image.bmp >> out.bmp

echo Produced out.bmp
display out.bmp


To get emojis to work on buffer, need to send text one character at a time. 
It used to work with text such as ":date:", currently this does not work, 
instead need to use text such as

":date
 "
 
i.e. terminate emoji with newline (which will be sent as an Enter key press), 
then start the new line with a space before continuing.

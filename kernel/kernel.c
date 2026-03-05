void main_kernel() {
	const char *msg = "axiom-os booted";
	char *video = (char*) 0xb8000;
	// here 0xb8000 is the address for the display
	
	for (int i = 0; msg[i] != '\0'; i++) {
		video[i * 2] = msg[i];
		video[i * 2 + 1] = 0x07;
	}
	// vga is a video grahics array
	// it is used as a standard for x86 devices
	// so to display text we need 2 bytes
	// so character is 1 byte and the color which is video[i * 2 + 1]
	// is another 1 byte
	// so that is why we are looping through to 
	// give each character of the msg to the screen
	while(1) {
		asm("hlt");
	}
	// eventually
	// we need to do this
	// while(1) { scheduler(); }
}

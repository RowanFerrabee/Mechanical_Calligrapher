bool checkBTLinkConnected()
{
	if (nBTCurrentStreamIndex >= 0)
		return true; // An existing Bluetooth connection is present.
	return false;
}

task main()
{
	setBluetoothRawDataMode();  // set Bluetooth to "raw mode"
	while (!bBTRawMode)         // while the Bluecore is still NOT in raw mode (bBTRawMode == false):
	{
  	wait1Msec(1);               // wait for Bluecore to enter raw data mode
	}

	while (!checkBTLinkConnected()) {
		eraseDisplay();
		nxtDisplayCenteredTextLine(3, "BT not");
		nxtDisplayCenteredTextLine(4, "Connected");
		wait1Msec(3000);
	}

	nxtDisplayCenteredTextLine(3, "connected");

	while (true) {
		int bufferSize = 1;                             // will be the size of buffer.
		ubyte B[1];                    // create a ubyte array, 'BytesRead' of size 'bufferSize'.
		nxtReadRawBluetooth(&B[0], bufferSize);
		//if (BytesRead[0] > 100)
		nxtDisplayCenteredTextLine(0, "%d", B[0]);
	}
}

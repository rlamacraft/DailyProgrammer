package dp_regexFractals;

public class Cell {
	
	int colour;
	String reference;
	
	static final int WHITE = 1;
	static final int BLACK = 0;
	
	public Cell() {
		colour = Cell.WHITE;
		reference = "";
	}
	
	public void appendReference(char newChar) {
		reference = reference + newChar;
	}

}

package dp_rogueLike;

public class LootChest {

	private int x;
	private int y;
	private int value;
	
	public LootChest(int new_x, int new_y, int new_value) {
		x = new_x;
		y = new_y;
		value = new_value;
	}
	
	public int getX() {
		return x;
	}
	
	public int getY() {
		return y;
	}
	
	public int getValue() {
		return value;
	}
	
	public int emptyChest() {
		int tmp = value;
		value = 0;
		return tmp;
	}
}

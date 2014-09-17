package dp_rogueLike;

public class Player {
	
	private int x = 0;
	private int y = 0;
	
	public Player(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	public void setX(int newX) {
		x = newX;
	}
	
	public void setY(int newY) {
		y = newY;
	}
	
	public int getX() {
		return x;
	}
	
	public int getY() {
		return y;
	}

}

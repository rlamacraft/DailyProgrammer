package dp_rogueLike;

import java.io.IOException;
import java.util.Random;

public class Gameplay {

	public char[][] grid = new char[20][20];
	public LootChest[] chestList = new LootChest[10];
	public int score = 0;
	public int remainingMoves = 100;
	public Player singlePlayer;
	public boolean running = true;
	
	public Gameplay() {
		//nothing here
	}
	
	public void clearConsole() throws IOException {
		Runtime.getRuntime().exec("cls");
	}
	
	public void printGrid() {
		//clear
		try {
			clearConsole();
		} catch (IOException e) {
			//so something
		}
		
		for (int i = 0; i < 20; i++) {
			for (int j = 0; j < 20; j++) {
				if (j < 19) {
					System.out.print(grid[i][j]);
				} else {
					System.out.print(grid[i][j]);
				}
			}
			System.out.println("");
		}
		
		System.out.println("Score: " + score);
		System.out.println("Moves: " + remainingMoves);
	}
	
	public void movePlayer(Character direction) {
		switch (direction) {
			case 'w': changePlayerPos(-1,0); break;
			case 'a': changePlayerPos(0,-1); break;
			case 's': changePlayerPos(1,0); break;
			case 'd': changePlayerPos(0,1); break;
		}
		printGrid();
		remainingMoves--;
		if (remainingMoves == 0) {
			running = false;
		}
	}
	
	public void changePlayerPos(int x, int y) {
		
		grid[singlePlayer.getX()][singlePlayer.getY()] = ' ';
		if (singlePlayer.getX() + x > 0 && singlePlayer.getX() + x < 19) {
			singlePlayer.setX(singlePlayer.getX() + x);
		}
		if (singlePlayer.getY() + y > 0 && singlePlayer.getY() + y < 19) {
			singlePlayer.setY(singlePlayer.getY() + y);
		}
		
		if (grid[singlePlayer.getX()][singlePlayer.getY()] == 'x') {
			//if found loot chest
			for(LootChest eachChest: chestList) {
				if (singlePlayer.getX() == eachChest.getX() &&
						singlePlayer.getY() == eachChest.getY()) {
					score += eachChest.getValue();
				}
			}
		}
		
		grid[singlePlayer.getX()][singlePlayer.getY()] = 'T';
	}
	
	public void generateGrid() {
		//populate grid
		for (int i = 0;i<20;i++) {
			for (int j = 0; j<20;j++) {
				if (i==0 || i==19 || j==0 || j==19) {
					grid[i][j] = '#';
				} else {
					grid[i][j] = ' ';
				}
			}
		}
		
		Random randomGenerator = new Random();
		for (int i = 0; i< 10;i++) {
			int x = randomGenerator.nextInt(18) + 1;
			int y = randomGenerator.nextInt(18) + 1;
			int value = randomGenerator.nextInt(9) + 1;
			chestList[i] = new LootChest(x,y,value);
			grid[x][y] = 'x';
		}
		
		//create player
		singlePlayer = new Player(1,1);
		grid[1][1] = 'T';
		
		//printGrid
		printGrid();
	}
}

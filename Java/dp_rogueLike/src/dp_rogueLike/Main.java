package dp_rogueLike;

import java.util.Scanner;

public class Main {

	public static void main(String args[]) {
		Gameplay singlePlayer = new Gameplay();
		
		singlePlayer.generateGrid();
		Scanner input = new Scanner(System.in);
		Character userInput = ' ';
		
		do {
			userInput = input.next().charAt(0);
			if (userInput != 'q') {
	 			singlePlayer.movePlayer(userInput);
			} else {
				System.out.println("Quitting...");
			}
		} while(userInput!='q' && singlePlayer.running == true);
	}
	
}

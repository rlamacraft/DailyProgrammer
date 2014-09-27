package dp_lookAndSay;

import java.util.Scanner;

public class Main {
	
	public static String data = "";

	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		System.out.print("Enter iterations: ");
		int iterations = input.nextInt();
		System.out.print("Enter seed: ");
		String seed = input.next();
		input.close();
		
		data += seed;
		System.out.println(data);
		
		for(int iterator = 0;iterator<iterations-1;iterator++) {
			data = processData();
			System.out.println(data);
		}
	}
	
	public static String processData() {
		String ret = "";
		Character pointer = data.charAt(0);
		int pointerCounter = 0;
		for(int i = 0;i<data.length();i++) {
			if (pointer != data.charAt(i)) {
				ret += pointerCounter + "";
				ret += pointer + "";
				pointer = data.charAt(i);
				pointerCounter = 1;
			} else {
				pointerCounter++;
			}
		}
		ret += pointerCounter + "";
		ret += pointer + "";
		return ret;
	}
}
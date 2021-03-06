package dp_palidromProducts;

import java.util.Scanner;

public class Main {
	
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		Range firstRange = new Range(input.nextInt(),input.nextInt());
		Range secondRange = new Range(input.nextInt(),input.nextInt());
		
		for(int i = firstRange.lowerRange;i<=firstRange.upperRange;i++) {
			for(int j = secondRange.lowerRange;j<=secondRange.upperRange;j++) {
				String productResult = (i * j) + "";
				if (isPalindrome(productResult)) {
					System.out.println("true");
					break;
				}
			}
		}
	}

	public static boolean isPalindrome(String input) {
		//boolean isPalindromic = true;
		for(int i = 0; i < input.length() / 2;i++) {
			if (input.charAt(i) != input.charAt(input.length()-i-1)) {
				return false;
			}
		}
		return true;
	}
}

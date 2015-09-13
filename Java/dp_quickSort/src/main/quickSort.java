//package main;

import java.util.ArrayList;
import java.util.Scanner;

public class quickSort {

	public static ArrayList<Float> quickSort(ArrayList<Float> list) {
		int listLength = list.size();
		if (listLength <= 1) {
			return list;
		} else if (listLength == 2) {
			if (list.get(0) < list.get(1)) {
				return list;
			} else {
				ArrayList<Float> tmp = new ArrayList<Float>();
				tmp.add(list.get(1));
				tmp.add(list.get(0));
				return tmp;
			}
		} else {
			float pivot = list.get(0);
			ArrayList<Float> list_S = new ArrayList<Float>();
			ArrayList<Float> list_G = new ArrayList<Float>();
			for (int i = 1;i<listLength;i++) {
				if (list.get(i) < pivot) {
					list_S.add(list.get(i));
				} else {
					list_G.add(list.get(i));
				}
			}

			ArrayList<Float> sorted_S = quickSort(list_S);
			ArrayList<Float> sorted_G = quickSort(list_G);
			ArrayList<Float> result = new ArrayList<Float>();

			for (Float eachNum: sorted_S) {
				result.add(eachNum);
			}
			result.add(pivot);
			for (Float eachNum: sorted_G) {
				result.add(eachNum);
			}

			return result;
		}
	}

	public static void main(String args[]) {
		/*Scanner input = new Scanner(System.in);
		ArrayList<Float> initialList = new ArrayList<Float>();

		System.out.print("Enter the number of elements in your list: ");
		int numOfElements = input.nextInt();
		System.out.println("Now enter each element on a new line");
		for (int i = 0;i<numOfElements;i++ ) {
			initialList.add(input.nextFloat());
		}

		ArrayList<Float> sortedList = quickSort(initialList);

		for (int i = 0;i<numOfElements;i++) {
			System.out.print(sortedList.get(i) + ", ");
		}*/

		ArrayList<Float> list = new ArrayList<Float>();
		list.add(new Float(3.2));
	  list.add(new Float(42));
	  list.add(new Float(5.8));
		System.out.println(quickSort(list));
	}
}

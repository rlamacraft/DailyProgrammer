package stuff;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Main {
	
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		
		//initial data input
		System.out.print("Enter the starting coordinates: ");
		PositionVector startLocation = new PositionVector(input.nextLine());
		Matrix endTransformation = null;
		
		//repeat getting commands from the user
		String userCommand;
		do {
			userCommand = input.nextLine();
			if (!userCommand.equals("finish()")) {
				//dissect command
				int functionType = identifyFunction(userCommand);
				ArrayList<Double> matrixParameters = getParameters(userCommand);
				
				Matrix newTransformation = new Matrix();
				newTransformation.setParameters(matrixParameters);
				newTransformation.setType(functionType);
				endTransformation = newTransformation.addTransformation(endTransformation);
				System.out.println(endTransformation);
			}
		} while (!userCommand.equals("finish()"));
		//perform endTransformation on startLocation to produce endLocation
		PositionVector endLocation = performTransformation(endTransformation,startLocation);
		System.out.println(endLocation);
	}
	
	//perfroms a matrix transformation on a position vector
	public static PositionVector performTransformation(Matrix transformation, PositionVector initialVector) {
		PositionVector endLocation = new PositionVector();
		endLocation.data[0] = (initialVector.data[0] * transformation.data[0][0])
							+ (initialVector.data[1] * transformation.data[0][1])
							+ (initialVector.data[2] * transformation.data[0][2]);
		endLocation.data[1] = (initialVector.data[0] * transformation.data[1][0])
							+ (initialVector.data[1] * transformation.data[1][1])
							+ (initialVector.data[2] * transformation.data[1][2]);
		endLocation.data[2] = (initialVector.data[0] * transformation.data[2][0])
							+ (initialVector.data[1] * transformation.data[2][1])
							+ (initialVector.data[2] * transformation.data[2][2]);
		return endLocation;
	}
	
	//disects the parameters from the user's command
	public static ArrayList<Double> getParameters(String command) {
		final String REGEX_NUM = "[0-9]*.?[0-9]+";
		final double PI = 3.14159265359;
		final double TAU = PI * 2;
		
		int splitIndex = 0;
		for (int i = 0;i < command.length();i++) {
			if (command.charAt(i) == '(') {
				splitIndex = i;
			}
		}
		String paraInput = command.substring(splitIndex+1,command.length() - 1);
		
		if (paraInput.equals("x")) {
			ArrayList<Double> ret = new ArrayList<Double>();
			ret.add(0.0);
			return ret;
		} else if (paraInput.equals("y")) {
			ArrayList<Double> ret = new ArrayList<Double>();
			ret.add(1.0);
			return ret;
		} else if (paraInput.matches(REGEX_NUM + "," + REGEX_NUM + "," + REGEX_NUM + "/" + REGEX_NUM)) { //is a number followed by a '/' followed by another number
			ArrayList<Double> parasList = new ArrayList<Double>();
			int lowerBound = 0;
			int upperBound = -1;
			for (int i = 0;i < paraInput.length();i++) {
				if (paraInput.charAt(i) == ',') {
					lowerBound = upperBound + 1;
					upperBound = i;
					parasList.add(Double.parseDouble(paraInput.substring(lowerBound,upperBound)));
				}
			}
			int divisionIndex = paraInput.indexOf('/');
			double firstNum = Double.parseDouble(paraInput.substring(upperBound+1,divisionIndex));
			double secondNum = Double.parseDouble(paraInput.substring(divisionIndex+1,paraInput.length()));
			double result = (firstNum / secondNum) * TAU;
			parasList.add(result);
			return parasList;
		} else {
			ArrayList<Double> parasList = new ArrayList<Double>();
			int lowerBound = 0;
			int upperBound = splitIndex;
			for (int i = 0;i < paraInput.length();i++) {
				if ((paraInput.charAt(i) == ',') || (command.charAt(i) == ')')) {
					lowerBound = upperBound + 1;
					upperBound = i;
					System.out.println(paraInput.substring(lowerBound,upperBound));
					parasList.add(Double.parseDouble(paraInput.substring(lowerBound,upperBound)));
				}
			}
			return parasList;
		}
	}
	
	//identifies the function of the user command, returning the function's id
	public static int identifyFunction(String command) {
		Map<String,Integer> functions = new HashMap<String,Integer>();
		functions.put("translate",0);
		functions.put("rotate",1);
		functions.put("scale", 2);
		functions.put("reflect", 3);
		
		int splitIndex = 0;
		for (int i = 0;i < command.length();i++) {
			if (command.charAt(i) == '(') {
				splitIndex = i;
			}
		}
		String functionName = command.substring(0,splitIndex);
		
		return functions.get(functionName);
	}
}

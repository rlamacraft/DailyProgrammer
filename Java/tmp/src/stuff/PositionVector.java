package stuff;

public class PositionVector {

	public double[] data = new double[3];
	
	public PositionVector() {
		data[0] = 0;
		data[1] = 0;
		data[2] = 1;
	}
	
	public PositionVector(double x, double y) {
		data[0] = x;
		data[1] = y;
		data[2] = 1;
	}
	
	public PositionVector(String desc) {
		int splitIndex = 0;
		for (int i = 0;i < desc.length();i++) {
			if (desc.charAt(i) == ',') {
				splitIndex = i;
			}
		}
		String firstHalf = desc.substring(1,splitIndex);
		String secondHalf = desc.substring(splitIndex+1,desc.length()-1);
		
		data[0] = Double.parseDouble(firstHalf);
		data[1] = Double.parseDouble(secondHalf);
		data[2] = 1;
	}
	
	public String toString() {
		return "[" + String.format("%.2f",data[0]) + "," + String.format("%.2f",data[1]) + "," + String.format("%.2f",data[2]) + "]";
	}
}
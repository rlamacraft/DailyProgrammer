package stuff;

import java.util.ArrayList;

public class Matrix {
	
	public double[][] data = new double[3][3];
	public ArrayList<Double> parameters;
	
	public final double PI = 3.14159265359;
	public final double TAU = PI * 2;
	
	public Matrix() {
		//nothing to see here
	}
	
	public Matrix(double[][] existingData) {
		data = existingData;
	}
	
	//utility function for rounding to 2dp
	public static double round(double value, int places) {
	    if (places < 0) throw new IllegalArgumentException();

	    long factor = (long) Math.pow(10, places);
	    value = value * factor;
	    long tmp = Math.round(value);
	    return (double) tmp / factor;
	}
	
	public void setParameters(ArrayList<Double> paras) {
		parameters = paras;
	}
	
	public void setType(int transformationType) {
		switch(transformationType) {
			case 0:
				//Translate
				setSelfToTranslate();
				break;
			case 1:
				//Rotate 
				setSelfToRotate();
				break;
			case 2:
				//Scale
				setSelfToScale();
				break;
			case 3:
				//Reflect
				setSelfToReflect();
				break;
		}
	}
	
	private void setSelfToTranslate() {
		/*sets this matrix to a translate matrix based on passed parameters
		 * 
		 * Translation matrix is
		 * 1 0 x
		 * 0 1 y
		 * 0 0 1
		 * 
		 * where (x,y) is the translation vector
		 */
		data[0][0] = 1;
		data[0][1] = 0;
		data[0][2] = parameters.get(0);
		data[1][0] = 0;
		data[1][1] = 1;
		data[1][2] = parameters.get(1);
		data[2][0] = 0;
		data[2][1] = 0;
		data[2][2] = 1;
	}
	
	private void setSelfToRotate() {
		/*
		 * for translate(x,y,S):
		 * 	- translate(-x,-y)
		 *  - rotate(S)
		 *  - translate(x,y)
		 */
		
		//create translation matrix for offset of pivot of rotation
		ArrayList<Double> offsetParameters = new ArrayList<Double>();
		offsetParameters.add(-(parameters.get(0)));
		offsetParameters.add(-(parameters.get(1)));
		
		Matrix rotationOffset = new Matrix();
		rotationOffset.setParameters(offsetParameters);
		rotationOffset.setType(0);
		
		//add rotation matrix to offset translation
		rotateAroundOrigin();
		data = multiplyMatrices(rotationOffset).data;
		
		//create reverse translation matrix for returning to initial position
		ArrayList<Double> offsetParametersReturn = new ArrayList<Double>();
		offsetParametersReturn.add(parameters.get(0));
		offsetParametersReturn.add(parameters.get(1));
		
		Matrix rotationOffsetReturn = new Matrix();
		rotationOffsetReturn.setParameters(offsetParametersReturn);
		rotationOffsetReturn.setType(0);
		
		Matrix tmp = new Matrix();
		tmp.data = data;
		data = rotationOffsetReturn.data;
		rotationOffsetReturn.data = tmp.data;
		
		data = multiplyMatrices(rotationOffsetReturn).data;
	}
	
	private void setSelfToScale() {
		/*
		 * for translate(x,y,S):
		 * 	- translate(-x,-y)
		 *  - scale(S)
		 *  - translate(x,y)
		 */
		
		//create translation matrix for offset of pivot of rotation
		ArrayList<Double> offsetParameters = new ArrayList<Double>();
		offsetParameters.add(-(parameters.get(0)));
		offsetParameters.add(-(parameters.get(1)));
		
		Matrix scaleOffset = new Matrix();
		scaleOffset.setParameters(offsetParameters);
		scaleOffset.setType(0);
		
		//add rotation matrix to offset translation
		scaleAroundOrigin();
		data = multiplyMatrices(scaleOffset).data;
		
		//create reverse translation matrix for returning to initial position
		ArrayList<Double> scaleParametersReturn = new ArrayList<Double>();
		scaleParametersReturn.add(parameters.get(0));
		scaleParametersReturn.add(parameters.get(1));
		
		Matrix scaleOffsetReturn = new Matrix();
		scaleOffsetReturn.setParameters(scaleParametersReturn);
		scaleOffsetReturn.setType(0);
		
		Matrix tmp = new Matrix();
		tmp.data = data;
		data = scaleOffsetReturn.data;
		scaleOffsetReturn.data = tmp.data;
		
		data = multiplyMatrices(scaleOffsetReturn).data;
	}
	
	private void setSelfToReflect() {
		//sets this matrix to a reflect matrix based on passed parameters
		if (parameters.get(0) == 0) {
			/*Set grid to reflection in x axis
			 * 
			 *  Reflection in x axis matrix is
			 *  1  0  0
			 *  0 -1  0
			 *  0  0  1
			 */
			data[0][0] = 1;
			data[0][1] = 0;
			data[0][2] = 0;
			data[1][0] = 0;
			data[1][1] = -1;
			data[1][2] = 0;
			data[2][0] = 0;
			data[2][1] = 0;
			data[2][2] = 1;
		} else if(parameters.get(0) == 1) {
			/*set grid to reflection in y axis
			 * 
			 * Reflection in y axis is
			 * -1 0 0
			 *  0 1 0
			 *  0 0 1
			 */
			data[0][0] = -1;
			data[0][1] = 0;
			data[0][2] = 0;
			data[1][0] = 0;
			data[1][1] = 1;
			data[1][2] = 0;
			data[2][0] = 0;
			data[2][1] = 0;
			data[2][2] = 1;
		}
	}
	
	public void rotateAroundOrigin() {
		/*sets this matrix to a rotate matrix based on passed parameters
		 * 
		 * Rotation matrix is
		 * cos(n)  -sin(n)  0
		 * sin(n)  cos(n)   0
		 * 0       0        1
		 * where n is the angle of rotation
		 */
		
		double angle = parameters.get(2);
		
		data[0][0] = Math.cos(angle);
		data[0][1] = -Math.sin(angle);
		data[0][2] = 0;
		data[1][0] = Math.sin(angle);
		data[1][1] = Math.cos(angle);
		data[1][2] = 0;
		data[2][0] = 0;
		data[2][1] = 0;
		data[2][2] = 1;
	}
	
	public void scaleAroundOrigin() {
		/*Sets this matrix to a scale matrix based on passed parameters
		 * 
		 *  Scaling matrix is
		 *  n 0 0
		 *  0 n 0
		 *  0 0 1
		 *  
		 *  ,where n is the scale factor
		 */
		data[0][0] = parameters.get(2);
		data[0][1] = 0;
		data[0][2] = 0;
		data[1][0] = 0;
		data[1][1] = parameters.get(2);
		data[1][2] = 0;
		data[2][0] = 0;
		data[2][1] = 0;
		data[2][2] = 1;
	}
	
	//combines two matrixes to form one transformation
	public Matrix addTransformation(Matrix previous) {
		if (previous == null) {
			return new Matrix(data);
		} else {
			return multiplyMatrices(previous);
		}
	}
	
	//concatenates matrix transformations so that only one transformation needs to be applied
	public Matrix multiplyMatrices(Matrix other) {
		/*multiply other with self
		 * 
		 * this works because:
		 * |a b c|   |j k l|   |aj+bm+cp ak+bn+cq al+bo+cr|
		 * |d e f| * |m n o| = |dj+em+fp dk+en+fq dl+eo+fr|
		 * |g h i|   |p q r|   |gj+hm+ip gk+hn+iq gl+ho+ir|
		 */
		Matrix result = new Matrix();
		
		double[][] first = data;
		double[][] second = other.data;
		
		result.data[0][0] = (first[0][0]*second[0][0]) + (first[0][1]*second[1][0]) + (first[0][2]*second[2][0]);
		result.data[0][1] = (first[0][0]*second[0][1]) + (first[0][1]*second[1][1]) + (first[0][2]*second[2][1]);
		result.data[0][2] = (first[0][0]*second[0][2]) + (first[0][1]*second[1][2]) + (first[0][2]*second[2][2]);
		
		result.data[1][0] = (first[1][0]*second[0][0]) + (first[1][1]*second[1][0]) + (first[1][2]*second[2][0]);
		result.data[1][1] = (first[1][0]*second[0][1]) + (first[1][1]*second[1][1]) + (first[1][2]*second[2][1]);
		result.data[1][2] = (first[1][0]*second[0][2]) + (first[1][1]*second[1][2]) + (first[1][2]*second[2][2]);
		
		result.data[2][0] = (first[2][0]*second[0][0]) + (first[2][1]*second[1][0]) + (first[2][2]*second[2][0]);
		result.data[2][1] = (first[2][0]*second[0][1]) + (first[2][1]*second[1][1]) + (first[2][2]*second[2][1]);
		result.data[2][2] = (first[2][0]*second[0][2]) + (first[2][1]*second[1][2]) + (first[2][2]*second[2][2]);
		
		return result;
	}
	
	public String toString() {
		String firstLine = "|" + data[0][0] + " " + data[0][1] + " " + data[0][2] + "|";
		String secondLine = "|" + data[1][0] + " " + data[1][1] + " " + data[1][2] + "|";
		String thirdLine = "|" + data[2][0] + " " + data[2][1] + " " + data[2][2] + "|";
		return firstLine + "\n" + secondLine + "\n" + thirdLine + "\n";
	}

}
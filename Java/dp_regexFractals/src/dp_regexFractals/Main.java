package dp_regexFractals;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

import javax.imageio.ImageIO;

public class Main {

	public static void main (String args[]) {
		Scanner input = new Scanner(System.in);
		MakeFractal newFractal = new MakeFractal(input.nextInt());
		newFractal.createImage(input.next());
		input.close();
		BufferedImage outputImage = newFractal.printImage();
		
		String outputFileName = "output.png";
		try {
			ImageIO.write(outputImage, "PNG", new File(outputFileName));
			System.out.println("created image");
		} catch (IOException e) {
			System.out.println("creating image failed");
			e.printStackTrace();
		}
	}
	
}

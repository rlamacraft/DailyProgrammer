import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class testing {

    public static void main(String args[]) {
        int dimension = 64; //for now, this needs to be < 255
        testing someTests = new testing();
//        someTests.saveImage(someTests.testingImage(dimension), "allWhite");
//        someTests.saveImage(someTests.testingGradient(dimension), "redGradient");
//        someTests.saveImage(someTests.blueGreenGradient(dimension), "blueGreenGradient");


        Scanner input = new Scanner(System.in);
        int width = input.nextInt();
        int height = input.nextInt();
        int[] left_rgb = {input.nextInt(), input.nextInt(), input.nextInt()};
        int[] right_rgb = {input.nextInt(), input.nextInt(), input.nextInt()};
        someTests.saveImage(someTests.specificGradientWithDim(width, height, left_rgb, right_rgb), "myGradient");
    }

    /**
     * Creates an image with a gradient from left to right
     * @param width Width of the image
     * @param height Height of the image
     * @param left_rgb The rgb left-hand color
     * @param right_rgb The rgb right-hand color
     * @return The generated image
     */
    private BufferedImage specificGradientWithDim(int width, int height, int[] left_rgb, int[] right_rgb) {
        double rIncrement = (double) (right_rgb[0] - left_rgb[0]) / width;
        double gIncrement = (double) (right_rgb[1] - left_rgb[1]) / width;
        double bIncrement = (double) (right_rgb[2] - left_rgb[2]) / width;

        double rCounter = left_rgb[0];
        double gCounter = left_rgb[1];
        double bCounter = left_rgb[2];

        BufferedImage img = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
        WritableRaster raster = img.getRaster();

        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                int[] rgb = { (int) rCounter, (int) gCounter, (int) bCounter};
                raster.setPixel(i, j, rgb);
            }
            rCounter += rIncrement;
            gCounter += gIncrement;
            bCounter += bIncrement;
        }

        return img;
    }

    /**
     * Creates an image with a gradient from left to right
     * @param dimension Size of the image
     * @param left_rgb The rgb left-hand color
     * @param right_rgb The rgb right-hand color
     * @return The generated image
     */
    private BufferedImage specificGradient(int dimension, int[] left_rgb, int[] right_rgb) {
        int redCounter = (right_rgb[0] - left_rgb[0]) / dimension;
        int greenCounter = (right_rgb[1] - left_rgb[1]) / dimension;
        int blueCounter = (right_rgb[2] - left_rgb[2]) / dimension;

        BufferedImage img = new BufferedImage(dimension,dimension,BufferedImage.TYPE_INT_RGB);
        WritableRaster raster = img.getRaster();

        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                int[] rgb = {left_rgb[0] + redCounter*j, left_rgb[1] + greenCounter*j, left_rgb[2] + blueCounter*j};
                raster.setPixel(j, i, rgb);
            }
        }

        return img;
    }

    /**
     * Generates a blue to green gradient from left to right
     * @param dimension The size of the image
     * @return The generated image
     */
    private BufferedImage blueGreenGradient(int dimension) {
        int increment = (int) (255 / dimension);

        BufferedImage img = new BufferedImage(dimension,dimension,BufferedImage.TYPE_INT_RGB);
        WritableRaster raster = img.getRaster();
        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                int[] rgb = {0, j*increment, 255-(j*increment)}; //this multiplication based on the counter causes a gradient
                raster.setPixel(j, i, rgb);
            }
        }

        return img;
    }

    /**
     * Generates a red to white gradient from left to right
     * @param dimension The size of the image
     * @return The generated image
     */
    private BufferedImage testingGradient(int dimension) {
        int increment = (int) (255 / dimension);

        BufferedImage img = new BufferedImage(dimension,dimension,BufferedImage.TYPE_INT_RGB);
        WritableRaster raster = img.getRaster();
        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                int[] rgb = {255, j*increment, j*increment}; //this multiplication based on the counter causes a gradient
                raster.setPixel(j, i, rgb);
            }
        }

        return img;
    }

    /**
     * Generates a white square
     * @param dimension The size of the image
     * @return The generated image
     */
    private BufferedImage testingImage(int dimension) {
        BufferedImage img = new BufferedImage(dimension,dimension,BufferedImage.TYPE_INT_RGB);
        WritableRaster raster = img.getRaster();
        for (int i = 0; i < dimension; i++) {
            for (int j = 0; j < dimension; j++) {
                int[] rgb = {255, 255, 255};
                raster.setPixel(j, i, rgb);
            }
        }
        return img;
    }

    /**
     * Saves a given image into a png file
     * @param img The image
     * @param path The specified path and file name
     * @return Boolean value of success/failure, can be ignored for most cases
     */
    private Boolean saveImage(BufferedImage img, String path) {
        try {
            ImageIO.write(img, "PNG", new File(path));
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

}
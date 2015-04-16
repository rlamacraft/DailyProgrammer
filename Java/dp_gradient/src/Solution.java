import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

/**
 * Created by Robert on 16/04/15.
 */
public class Solution {

    public static void main(String args[]) {
        Solution potatoes = new Solution();
        Scanner input = new Scanner(System.in);
        int width = input.nextInt();
        int height = input.nextInt();
        int[] left_rgb = {input.nextInt(), input.nextInt(), input.nextInt()};
        int[] right_rgb = {input.nextInt(), input.nextInt(), input.nextInt()};
        potatoes.saveImage(potatoes.specificGradientWithDim(width, height, left_rgb, right_rgb), "output");
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

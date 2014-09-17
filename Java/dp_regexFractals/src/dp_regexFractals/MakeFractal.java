package dp_regexFractals;

import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;

public class MakeFractal {
	
	public Cell[][] grid;
	
	public MakeFractal(int size) {
		grid = new Cell[size][size];
		
		//fill grid
		for(int i =0;i<size;i++) {
			for(int j = 0;j<size;j++) {
				grid[i][j] = new Cell();
			}
		}
		
		grid = recursiveGridFill(grid);
	}
	
	public Cell[][] recursiveGridFill(Cell[][] input) {
		if(input.length == 1) {
			return input;
		} else {
			int halfSize = input.length / 2;
			
			//append 2 to top left
			Cell[][] topLeft = new Cell[halfSize][halfSize];
			for( int i = 0;i<halfSize;i++) {
				for( int j = 0;j<halfSize;j++) {
					input[i][j].appendReference('2');
					topLeft[i][j] = input[i][j];
				}
			}
			
			//append 1 to top right
			Cell[][] topRight = new Cell[halfSize][halfSize];
			for( int i = 0;i<halfSize;i++) {
				for( int j = halfSize;j<halfSize*2;j++) {
					input[i][j].appendReference('1');
					topRight[i][j-halfSize] = input[i][j];
				}
			}
			
			//append 3 to bottom left
			Cell[][] bottomLeft = new Cell[halfSize][halfSize];
			for( int i = halfSize;i<halfSize*2;i++) {
				for( int j = 0;j<halfSize;j++) {
					input[i][j].appendReference('3');
					bottomLeft[i-halfSize][j] = input[i][j];
				}
			}
			
			//append 4 to bottom right
			Cell[][] bottomRight = new Cell[halfSize][halfSize];
			for( int i = halfSize;i<halfSize*2;i++) {
				for( int j = halfSize;j<halfSize*2;j++) {
					input[i][j].appendReference('4');
					bottomRight[i-halfSize][j-halfSize] = input[i][j];
				}
			}
			
			//recurisve call
			topLeft = recursiveGridFill(topLeft);
			topRight = recursiveGridFill(topRight);
			bottomLeft = recursiveGridFill(bottomLeft);
			bottomRight = recursiveGridFill(bottomRight);
			
			//put back together
			Cell[][] output = new Cell[input.length][input.length];
			for( int i = 0;i<halfSize;i++) {
				for( int j = 0;j<halfSize;j++) {
					output[i][j] = topLeft[i][j];
				}
			}
			for( int i = 0;i<halfSize;i++) {
				for( int j = halfSize;j<halfSize*2;j++) {
					output[i][j] = topRight[i][j-halfSize];
				}
			}
			for( int i = halfSize;i<halfSize*2;i++) {
				for( int j = 0;j<halfSize;j++) {
					output[i][j] = bottomLeft[i-halfSize][j];
				}
			}
			for( int i = halfSize;i<halfSize*2;i++) {
				for( int j = halfSize;j<halfSize*2;j++) {
					output[i][j] = bottomRight[i-halfSize][j-halfSize];
				}
			}
			
			return output;
		}
	}
	
	public void createImage(String regex) {
		for(int i = 0;i<grid.length;i++) {
			for(int j = 0;j<grid.length;j++) {
				if(grid[i][j].reference.matches(regex)) {
					grid[i][j].colour = Cell.BLACK;
				}
			}
		}
	}
	
	public BufferedImage printImage() {
		BufferedImage img = new BufferedImage(grid.length,grid.length,BufferedImage.TYPE_INT_RGB);
		
		WritableRaster raster = img.getRaster();
		
		for(int i = 0;i<grid.length;i++) {
			for(int j = 0;j<grid.length;j++) {
				int Cellcolour = grid[i][j].colour;
				//int colour = Cellcolour == Cell.BLACK ? 0 : 1; //if black, set 1 else 0
				int[] rgb = {Cellcolour*255,Cellcolour*255,Cellcolour*255};
				raster.setPixel(j,i,rgb);
			}
		}
		
		/*int[] tmp = {0,0,0};
		raster.setPixel(0,0,tmp);*/
		
		return img;
	}
	
	public void printGrid() {
		for(int i = 0;i<grid.length;i++) {
			for(int j = 0;j<grid.length;j++) {
				if(j<grid.length-1) {
					System.out.print(grid[i][j].reference + ",");
				} else {
					System.out.print(grid[i][j].reference);
				}
			}
			System.out.println();
		}
	}
	
	public void printGridImage() {
		for(int i = 0;i<grid.length;i++) {
			for(int j = 0;j<grid.length;j++) {
				if(j<grid.length-1) {
					System.out.print(grid[i][j].colour + ",");
				} else {
					System.out.print(grid[i][j].colour);
				}
			}
			System.out.println();
		}
	}

}

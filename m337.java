//https://redd.it/78twyd
import java.io.File;
import java.util.ArrayList;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

class m337
{
	public static void main(String... args) throws Exception
	{
		String extension = args[0].substring(args[0].lastIndexOf(".") + 1);
		BufferedImage image = ImageIO.read(new File(args[0]));
		BufferedImage output = new BufferedImage(image.getWidth(), image.getHeight(), image.getType());
		for(int y = 0; y < image.getHeight(); y++)
		{
			ArrayList<Integer> row = getPixelRow(image, y);
			int nonGray = findNonGray(row);
			if(nonGray != -1)
			{
				ArrayList<Integer> shifted = shiftRight(row, nonGray);
				setPixelRow(output, y, shifted);
			}
			else
			{
				setPixelRow(output, y, row);
			}
		}
		ImageIO.write(output, extension, new File("unscrambled_" + args[0]));
	}

	public static ArrayList<Integer> shiftRight(ArrayList<Integer> row, int amount)
	{
		int start = amount;
		ArrayList<Integer> sub = new ArrayList<Integer>(row.subList(amount + 1, row.size()));
		//row.removeRange(amount + 1, row.size());
		row.subList(amount + 1, row.size()).clear();
		row.addAll(0, sub);
		return row;
	}

	public static boolean isGrayScale(int pixel)
	{
		int red		= (pixel & 0xff0000) >> 16;
		int green	= (pixel & 0x00ff00) >> 8;
		int blue	= (pixel & 0x0000ff) >> 0;
		return red == green && green == blue;
	}

	public static int findNonGray(ArrayList<Integer> pixels)
	{
		for(int i = 0; i < pixels.size(); i++)
			if(!isGrayScale(pixels.get(i)))
				return i;
		return -1;
	}

	public static ArrayList<Integer> getPixelRow(BufferedImage image, int y)
	{
		int[] row = new int[image.getWidth() * 1];
		image.getRGB(0, y, image.getWidth(), 1, row, 0, image.getWidth());
		return toList(row);
	}

	public static ArrayList<Integer> toList(int[] array)
	{
		ArrayList<Integer> list = new ArrayList<Integer>();
		for(int i = 0; i < array.length; i++)
			list.add(array[i]);
		return list;
	}

	public static void setPixelRow(BufferedImage image, int y, ArrayList<Integer> row)
	{
		for(int x = 0; x < row.size(); x++)
			image.setRGB(x, y, row.get(x));
	}
}

//https://redd.it/7qn07r
import java.util.*;
import java.util.stream.*;

class e347
{
	public static void main(String... args)
	{
		List<Duration> records = new LinkedList<>();
		for(Scanner sc = new Scanner(System.in); sc.hasNextLine();)
		{
			String[] parts = sc.nextLine().trim().split(" ");
			Duration entry = new Duration(
				Integer.parseInt(parts[0]),
				Integer.parseInt(parts[1])
			);

			boolean overlapped = false;
			for(Duration record: records)
			{
				overlapped = false;
				if(record.canOverlap(entry) || entry.canOverlap(record))
				{
					overlapped = true;
					records.add(record.join(entry));
					records.remove(record);
					break;
				}
			}
			if(!overlapped)
				records.add(entry);
		}
		System.out.println(records.stream().mapToInt(a -> a.difference()).sum());
	}
}

class Duration
{
	public int a;
	public int b;

	public Duration(int a, int b)
	{
		this.a = a;
		this.b = b;
	}

	int difference()
	{
		return Math.abs(a - b);
	}

	boolean canOverlap(Duration other)
	{
		if(a <= other.a && b >= other.b)
			return true;
		if(a >= other.a && b <= other.b)
			return true;
		if(a <= other.a && b <= other.b && b >= other.a)
			return true;
		if(a >= other.a && b >= other.b && a <= other.b)
			return true;
		return false;
	}

	Duration join(Duration other)
	{
		return new Duration(
			Math.min(a, other.a),
			Math.max(b, other.b)
		);
	}

	@Override
	public String toString()
	{
		return "[" + a + ", " + b + "]";
	}
}

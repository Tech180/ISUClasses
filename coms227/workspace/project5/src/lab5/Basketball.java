package lab5;

public class Basketball {
	private boolean isInflated;
	private double diameter;
	 
	 public Basketball(double givenDiameter)
	  {
		  isInflated = false;
		  diameter = givenDiameter;
	  }

	  public boolean isDribbleable()
	  {
		  return isInflated;
	  }

	  public double getDiameter()
	  {
		 return diameter;
	  }

	  public double getCircumference()
	  {
		  double result = Math.PI * diameter;
		  return result;
	  }

	  public void inflate()
	  {
		isInflated = true;
	  }
	  

}

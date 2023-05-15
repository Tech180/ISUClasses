package postage3;

public class PostageUtil
{
  /**
   * Returns the cost of postage for a letter of the given weight.
   * @param weight
   *   given weight in ounces
   * @return
   *   cost of postage for the weight
   */
  public static double computePostage(double weight)
  {
	  double cost = .47;
	  if (weight > 1){
		  cost = Math.ceil(weight - 1) * .21;
	  }
	  if (weight > 3.5){
		  cost = cost + .47;
	  }
	  // TODO
	return cost;
  }
}
package postage2;

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
	  if (weight <= 1){
		        return .47;
	  }
	  else if (weight > 1){
		  return .47 + Math.ceil(weight - 1) * .21;
	  }
	  else if (weight > 3.5){
		  return .94 + Math.ceil(weight - 1) * .21;
	  }
	  else{
		  return .47 + Math.ceil(weight - 1) * .21;
	  }
	  // TODO
  }
}
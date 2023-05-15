package lab4;
/**
 * This class models a piggy bank.  A piggy bank can hold a
 * fixed maximum number of coins.  Once the number of coins reaches
 * the maximum, the piggy bank is full and no more coins can be added.
 * It is possible to <em>smash</em> it to get all the coins out at once.
 * However, once it has been smashed, you can no longer put any coins in it.
 */
public class PiggyBank
{
  private int maxCoins;
  private int coins;
  private boolean busted;
  
  /**
   * Constructs an empty <code>PiggyBank</code> that can hold
   * the given maximum number of coins.
   * @param maxCoins
   *   maximum number of coins this <code>PiggyBank</code> can hold.
   */
  public PiggyBank(int maxCoins)
  {
    this.maxCoins = maxCoins;
  }
  
  /**
   * Adds some coins to this <code>PiggyBank</code> if possible; 
   * does nothing if it is already full or smashed.
   */
  public void addCoins(int howMany)
  {
    // if we don't have enough space, may not be able
    // to add all the coins
    int newCoins = howMany;
    int amountOfRoom = maxCoins - coins;
    if (newCoins > amountOfRoom)
    {
      newCoins = amountOfRoom;
    }
    
    // we can only add coins if not busted
    if (busted == false)
    {
      coins += newCoins;
    }
    
  }
  
  /**
   * Returns the number of coins in this <code>PiggyBank</code>.
   * @return
   *   number of coins
   */
  public int getNumCoins()
  {
    return coins;
  }
  
  /**
   * Returns true if this <code>PiggyBank</code> is full.
   * @return
   *   true if full, false otherwise
   */  
  public boolean isFull()
  {
    return coins == maxCoins;
  }
  
  /**
   * Returns true if this <code>PiggyBank</code> is smashed.
   * @return
   *   true if smashed, false otherwise
   */
  public boolean isSmashed()
  {
    if (busted == true)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  /**
   * Smashes this <code>PiggyBank</code>.
   */
  public void smash()
  {
    coins = 0;
    busted = true;
  }
}

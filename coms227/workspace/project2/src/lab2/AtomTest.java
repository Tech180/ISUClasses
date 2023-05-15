package lab2;

public class AtomTest {
	public static void main (String args[]){
		Atom Uranium = new Atom(92, 146, 92);
		
		System.out.println(Uranium.getAtomicMass());
		System.out.println(Uranium.getAtomicCharge());
		
		Uranium.decay();
		
		System.out.println(Uranium.getAtomicMass());
		System.out.println(Uranium.getAtomicCharge());
		
		
	}
}

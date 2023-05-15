package lab3;

import plotter.SimulationPlotter;

public class RabbitSimApp {
	public static void main (String [] args){
		SimulationPlotter plotter = new SimulationPlotter();
		
		RabbitModel myModel = new RabbitModel();
		
		plotter.simulate(myModel);
	}
}

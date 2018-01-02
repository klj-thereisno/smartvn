package fun.thereisno.task;

import fun.thereisno.init.InitApplication;

public class Task {

	private InitApplication init;
	
	public InitApplication getInit() {
		return init;
	}

	public void setInit(InitApplication init) {
		this.init = init;
	}
	
	public void fresh(){
		init.refresh();
	}
}

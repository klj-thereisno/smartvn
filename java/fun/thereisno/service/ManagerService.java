package fun.thereisno.service;

import fun.thereisno.entity.Manager;

public interface ManagerService {

	Manager getManagerByUserName(String userName);
	
	void modifyPassword(Manager manager);

}

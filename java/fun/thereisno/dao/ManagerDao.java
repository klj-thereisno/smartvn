package fun.thereisno.dao;

import fun.thereisno.entity.Manager;

public interface ManagerDao {

	Manager getManagerByUserName(String userName);
	
	void modifyPassword(Manager manager);
}

package fun.thereisno.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import fun.thereisno.dao.ManagerDao;
import fun.thereisno.entity.Manager;
import fun.thereisno.service.ManagerService;

@Service
public class ManagerServiceImpl implements ManagerService{

	@Resource
	private ManagerDao managerDao;
	
	public Manager getManagerByUserName(String userName) {
		return managerDao.getManagerByUserName(userName);
	}

	public void modifyPassword(Manager manager) {
		// TODO Auto-generated method stub
		managerDao.modifyPassword(manager);
	}

}

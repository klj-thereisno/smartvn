package fun.thereisno.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import fun.thereisno.dao.JarDao;
import fun.thereisno.entity.Jar;
import fun.thereisno.service.JarService;

@Service
public class JarServiceImpl implements JarService{

	@Resource
	private JarDao jarDao;
	
	public void saveUrl(Jar jar) {
		jarDao.saveUrl(jar);
	}

	public void saveFile(Jar jar) {
		jarDao.saveFile(jar);
	}

	public void delete(String id) {
		jarDao.delete(id);
	}

	public Jar getById(String id) {
		return jarDao.getById(id);
	}

	public List<Jar> listJar(Map<String, Object> map) {
		return jarDao.listJar(map);
	}

	public Integer count(Map<String, Object> map) {
		return jarDao.count(map);
	}

	public boolean exist(String name) {
		if(jarDao.exist(name) > 0)
			return true;
		return false;
	}

	public void addClick(String id) {
		jarDao.addClick(id);
	}

	public void addDown(String id) {
		jarDao.addDown(id);
	}

	public List<String> randomJar(Integer sum) {
		return jarDao.randomJar(sum);
	}

	public List<Jar> topJar(Integer sum) {
		return jarDao.topJar(sum);
	}

	public void update(Jar jar){
		jarDao.update(jar);
	}
}

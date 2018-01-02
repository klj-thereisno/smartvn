package fun.thereisno.dao;

import java.util.List;
import java.util.Map;

import fun.thereisno.entity.Jar;

public interface JarDao {
	
	void saveUrl(Jar jar);
	
	void saveFile(Jar jar);
	
	void delete(String id);
	
	Jar getById(String id);
	
	List<Jar> listJar(Map<String, Object> map);

	Integer count(Map<String, Object> map);
	
	int exist(String name);
	
	void addClick(String id);
	
	void addDown(String id);
	
	List<String> randomJar(Integer sum);
	
	List<Jar> topJar(Integer sum);
	
	void update(Jar jar);
	
}

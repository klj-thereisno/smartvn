package fun.thereisno.init;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import fun.thereisno.service.JarService;

public class InitApplication implements ApplicationContextAware, ServletContextListener{

	private static ApplicationContext ac;
	
	private static ServletContext application;
	
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		ac = applicationContext;
	}

	public void contextInitialized(ServletContextEvent sce) {
		application = sce.getServletContext();
		refresh();
	}

	public void refresh() {
		JarService jarService = ac.getBean(JarService.class);
		application.setAttribute("topJar", jarService.topJar(60));
	}
}

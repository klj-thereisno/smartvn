package fun.thereisno.controller;

import java.io.PrintWriter;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import fun.thereisno.entity.Manager;
import fun.thereisno.service.ManagerService;
import fun.thereisno.util.PropertiesUtil;

@Controller
@RequestMapping("manage")
public class ManagerController {

	private final String salt = PropertiesUtil.getKey("salt");
	
	@Resource
	private ManagerService managerService;
	
	/**
	 * username区分大小写，提前检验。
	 * @param manager
	 * @param out
	 */
	@RequestMapping("login")
	public void login(Manager manager, PrintWriter out){
		Subject subject = SecurityUtils.getSubject();
		Md5Hash hash = new Md5Hash(manager.getPassword(), salt);
		String msg = "{\"success\":true}";
		Manager tmp = managerService.getManagerByUserName(manager.getUserName());
		try{
			if(tmp.getUserName().equals(manager.getUserName()))
				subject.login(new UsernamePasswordToken(manager.getUserName(), hash.toString()));
			else
				msg = "{\"errMsg\":\"username or password error!\"}";
		}catch(Exception e){
			msg = "{\"errMsg\":\"username or password error!\"}";
		}
		out.print(msg);
	}
	
	@PostMapping(value = "admin/valid", params = {"username","password"})
	public void md5(String password, String username, PrintWriter out){
		Manager manager = managerService.getManagerByUserName(username);
		String s = new Md5Hash(password,salt).toString();
		if(manager != null && manager.getPassword().equals(s))
			out.print("{\"success\":true}");
		else
			out.print("{\"success\":false}");
	}
	
	@PostMapping("admin/{id}")
	public void update(Manager manager, PrintWriter out){
		manager.setPassword(new Md5Hash(manager.getPassword(),salt).toString());
		managerService.modifyPassword(manager);
		out.print("{\"success\":true}");
	}
	
	@GetMapping("admin/logout")
	public void logout(PrintWriter out){
		SecurityUtils.getSubject().logout(); // getSession().removeAttribute("currentUser");// logout();
		// ((HttpServletRequest)req).getSession().invalidate();
		out.print("{\"success\":true}");
	}
	
}

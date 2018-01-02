package fun.thereisno.realm;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;

import fun.thereisno.entity.Manager;
import fun.thereisno.service.ManagerService;

public class MyRealm extends AuthorizingRealm{

	@Resource
	private ManagerService managerService;
	
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		String userName = (String) token.getPrincipal();
		Manager manager = managerService.getManagerByUserName(userName);
		if(manager != null){
			SecurityUtils.getSubject().getSession().setAttribute("currentUser", manager);
			return new SimpleAuthenticationInfo(manager.getUserName(), manager.getPassword(), getClass().getSimpleName());
		}
		return null;
	}

}

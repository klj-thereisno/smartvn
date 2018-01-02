package fun.thereisno.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import fun.thereisno.entity.Jar;
import fun.thereisno.entity.PageBean;
import fun.thereisno.index.JarIndex;
import fun.thereisno.jsoup.JarJsoup;
import fun.thereisno.service.JarService;
import fun.thereisno.util.DateJsonUtil;
import fun.thereisno.util.PageUtil;
import fun.thereisno.util.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

@Controller
@RequestMapping("jar")
public class JarController {

	@Resource
	private JarService jarService;
	
	@Resource
	private JarJsoup jarJsoup;
	
	@Resource
	private JarIndex jarIndex;
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		sdf.setLenient(true);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
	}
	
	@PostMapping("admin/list")
	public void list(Jar jar, Date s_b_releaseDate, Date s_e_releaseDate, PageBean pageBean, ServletResponse resp){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("jar", jar);
		map.put("s_b_releaseDate", s_b_releaseDate);
		map.put("s_e_releaseDate", s_e_releaseDate);
		map.put("pageBean", pageBean);
		JSONObject o = new JSONObject();
		JsonConfig config = new JsonConfig();
		config.registerJsonValueProcessor(Date.class, new DateJsonUtil());
		o.put("total", jarService.count(map));
		o.put("rows", JSONArray.fromObject(jarService.listJar(map), config));
		ResponseUtil.write(resp, o);
	}
	
	@PostMapping("admin")
	public void save(String method, MultipartFile jarFile, String jarUrl, ServletRequest req, ServletResponse resp){
		Jar jar = new Jar();
		JSONObject o = new JSONObject();
		if(method.equals("file")){
			String fileName = jarFile.getOriginalFilename();
			if(jarService.exist(fileName)){
				o.put("errMsg", "该jar包已存在，请选择新的jar包上传");
			}else{
				String dir = "/static/uploads/" + new SimpleDateFormat("yyyy/MM/").format(new Date());
				String path = req.getServletContext().getRealPath(dir);
				jar.setId(UUID.randomUUID().toString());
				jar.setName(fileName);
				jar.setUrl(dir);
				jar.setJarSize((int) jarFile.getSize());
				try {
					FileUtils.copyInputStreamToFile(jarFile.getInputStream(), new File(path + fileName));
					jarService.saveFile(jar);
					jarIndex.indexJar(jar.getId(), jar.getName());
					o.put("success", "jar文件上传成功");
				} catch (IllegalStateException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}else{
			int point = jarUrl.lastIndexOf("/") + 1;
			String jarName = jarUrl.substring(point, jarUrl.length());
			jarUrl = jarUrl.substring(0, point);
			if(jarService.exist(jarName)){
				o.put("errMsg", "该jar包已存在，请选择新的url上传");
			}else{
				try {
					jarJsoup.getPage(new URL(jarUrl));
					o.put("success", "url上传成功");
				} catch (MalformedURLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		ResponseUtil.write(resp, o);
	}
	
	@GetMapping("admin")
	public void delete(String id, PrintWriter out){
		String msg = "{\"success\":true}";
		jarService.delete(id);
		jarIndex.delete(id);
		out.print(msg);
	}
	
	@PostMapping("admin/update")
	public void update(Jar jar, PrintWriter out){
		String msg = "{\"success\":true}";
		jarService.update(jar);
		jarIndex.updateJar(jar.getId(), jar.getName());
		out.print(msg);
	}
	
	@GetMapping("list/{name}")
	public ModelAndView list(@PathVariable String name, @RequestParam(value = "page", defaultValue = "1") Integer page){
		PageBean pageBean = new PageBean(page, 10);
		ModelAndView mv = new ModelAndView("foreground/mainTemp");
		List<Jar> jarList = jarIndex.search(name, pageBean);
		Jar jar = jarList.remove(jarList.size() - 1);
		int total = jar.getJarSize();
		String pageCode = PageUtil.genPagi(name, total, page, pageBean.getRows());
		String head = "搜索&nbsp;&nbsp;<span style='color:red'>" + name + "</span>&nbsp;&nbsp;关键字共搜索到&nbsp;&nbsp;<span style='color:red'>" + total + "</span>&nbsp;&nbsp;个jar包";
		mv.addObject("pageCode", pageCode);
		mv.addObject("head", head);
		mv.addObject("jarList", jarList);
		mv.addObject("value", name);
		mv.addObject("mainPage", "search.jsp");
		return mv;
	}
	
	@GetMapping("{id}")
	public ModelAndView get(@PathVariable String id){
		ModelAndView mv = new ModelAndView("foreground/mainTemp");
		Jar jar = jarService.getById(id);
		jarService.addClick(id);
		if(jar != null){
			List<Jar> relList = jarIndex.search(jar.getName().replaceAll("-", " "), null);
			mv.addObject("jar", jar);
			mv.addObject("relList", relList);
		}else{
			mv.addObject("Info", "无效的访问");
		}
		mv.addObject("mainPage", "show.jsp");
		return mv;
	}
	
	@GetMapping("")
	public void down(@RequestParam String id, PrintWriter out){
		Jar jar = jarService.getById(id);
		jarService.addDown(id);
		out.print(jar.getUrl());
	}
	
}

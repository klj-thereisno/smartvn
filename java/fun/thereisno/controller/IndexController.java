package fun.thereisno.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import fun.thereisno.service.JarService;

@Controller
@RequestMapping("index")
public class IndexController {

	@Resource
	private JarService jarService;
	
	@GetMapping("")
	public ModelAndView randomJar(){
		ModelAndView mv = new ModelAndView("index");
		mv.addObject("tags", jarService.randomJar(500));
		return mv;
	}
	
}

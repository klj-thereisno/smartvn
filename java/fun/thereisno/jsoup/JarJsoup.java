package fun.thereisno.jsoup;

import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import fun.thereisno.entity.Jar;
import fun.thereisno.index.JarIndex;
import fun.thereisno.service.JarService;

public class JarJsoup {

	@Resource
	private JarService jarService;
	
	@Resource
	private JarIndex jarIndex;
	
	private Logger logger = LoggerFactory.getLogger(JarJsoup.class);
	
	public void getPage(URL url){
		logger.info("单页jar包爬取：" + url.toString());
		Jar jar = new Jar();
		Document doc = null;
		try {
			doc = Jsoup.parse(url, 0);
		} catch (IOException e) {
			logger.error("IOException错误：", e);
		}
		String html = doc.text();
		String[] nodes = html.split("\\s+(?!\\d{2}:\\d{2})");
		int start = 1;
		for(int i = 0; i < nodes.length; i++){
			if(nodes[i].equals("../")){
				start += i;
				break;
			}
		}
		Elements eles = doc.select("a:gt(0)");
		List<String> list = new ArrayList<String>();
		for (Element end : eles)
			list.add(end.attr("href"));
		for (String a : list) { // href == tilte == text == name
			if(a.endsWith(".jar") && !a.contains("sources") && !a.contains("javadoc")){
				for(int i = start; i < nodes.length; i += 3){
					if(nodes[i].endsWith(".jar")){
						if(nodes[i].endsWith("sources.jar")){
							jar.setSources(nodes[i]);
							jar.setSourcesSize(Integer.parseInt(nodes[i + 2]));
						}else if(nodes[i].endsWith("javadoc.jar")){
							jar.setDoc(nodes[i]);
							jar.setDocSize(Integer.parseInt(nodes[i + 2]));
						} else {
							jar.setName(nodes[i]);
							jar.setUrl(url.toString());
							try {
								jar.setReleaseDate(new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(nodes[i + 1]));
							} catch (ParseException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							jar.setJarSize(Integer.parseInt(nodes[i + 2]));
						}
					}
					if(nodes[i].endsWith(".pom")){
						jar.setPom(nodes[i]);
						jar.setPomSize(Integer.parseInt(nodes[i + 2]));
					}
				}
			}
		}
		jar.setId(UUID.randomUUID().toString());
		jarService.saveUrl(jar);
		jarIndex.indexJar(jar.getId(), jar.getName());
		logger.info("---------------单页获取jar包成功-----------");
	}
}
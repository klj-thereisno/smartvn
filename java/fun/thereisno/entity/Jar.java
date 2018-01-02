package fun.thereisno.entity;

import java.util.Date;

public class Jar{
	private String id;
	private String name;
	private String url;
	private Date releaseDate;
	private Date crawlDate;
	private Integer click;
	private Integer down;
	private String doc;
	private String sources;
	private String pom;
	private Integer jarSize;
	private Integer docSize;
	private Integer sourcesSize;
	private Integer pomSize;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public Date getReleaseDate() {
		return releaseDate;
	}
	public void setReleaseDate(Date releaseDate) {
		this.releaseDate = releaseDate;
	}
	public Date getCrawlDate() {
		return crawlDate;
	}
	public void setCrawlDate(Date crawlDate) {
		this.crawlDate = crawlDate;
	}
	public Integer getClick() {
		return click;
	}
	public void setClick(Integer click) {
		this.click = click;
	}
	public Integer getDown() {
		return down;
	}
	public void setDown(Integer down) {
		this.down = down;
	}
	public String getDoc() {
		return doc;
	}
	public void setDoc(String doc) {
		this.doc = doc;
	}
	public String getSources() {
		return sources;
	}
	public void setSources(String sources) {
		this.sources = sources;
	}
	public String getPom() {
		return pom;
	}
	public void setPom(String pom) {
		this.pom = pom;
	}
	public Integer getJarSize() {
		return jarSize;
	}
	public void setJarSize(Integer jarSize) {
		this.jarSize = jarSize;
	}
	public Integer getDocSize() {
		return docSize;
	}
	public void setDocSize(Integer docSize) {
		this.docSize = docSize;
	}
	public Integer getSourcesSize() {
		return sourcesSize;
	}
	public void setSourcesSize(Integer sourcesSize) {
		this.sourcesSize = sourcesSize;
	}
	public Integer getPomSize() {
		return pomSize;
	}
	public void setPomSize(Integer pomSize) {
		this.pomSize = pomSize;
	}
	public Jar() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Jar(String id, String name, String url, Date releaseDate, String doc, String sources, String pom, Integer jarSize,
			Integer docSize, Integer sourcesSize, Integer pomSize) {
		super();
		this.id = id;
		this.name = name;
		this.url = url;
		this.releaseDate = releaseDate;
		this.doc = doc;
		this.sources = sources;
		this.pom = pom;
		this.jarSize = jarSize;
		this.docSize = docSize;
		this.sourcesSize = sourcesSize;
		this.pomSize = pomSize;
	}
}
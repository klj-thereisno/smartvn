package fun.thereisno.util;

public class PageUtil {

	public static String genPagi(String targetUrl,int total,int currentPage,int pageSize){
		int totalPage = total % pageSize == 0 ? total / pageSize : total / pageSize + 1;
		StringBuilder sb=new StringBuilder("<nav><ul class='pagination pagination-sm'>");
		sb.append("<li><a href='"+targetUrl+"?page=1'>��ҳ</a></li>");
		if(currentPage==1){
			sb.append("<li class='disabled'><a href='#'>��һҳ</a></li>");
		}else{
			sb.append("<li><a href='"+targetUrl+"?page="+(currentPage-1)+"'>��һҳ</a></li>");
		}
		for(int i=currentPage-3;i<currentPage+3;i++){
			if(i<1 || i>totalPage){
				continue;
			}else if(i==currentPage){
				sb.append("<li class='active'><a href='#'>"+i+"</a></li>");
			}else{
				sb.append("<li><a href='"+targetUrl+"?page="+i+"'>"+i+"</a></li>");
			}
		}
		if(currentPage>=totalPage){
			sb.append("<li class='disabled'><a href='#'>��һҳ</a></li>");
		}else{
			sb.append("<li><a href='"+targetUrl+"?page="+(currentPage+1)+"'>��һҳ</a></li>");
		}
		sb.append("<li><a href='"+targetUrl+"?page="+totalPage+"'>βҳ</a></li>");
		sb.append("</ul></nav>");
		return sb.toString();
	}
}

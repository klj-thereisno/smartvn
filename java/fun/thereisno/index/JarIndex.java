package fun.thereisno.index;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.Fragmenter;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;
import org.apache.lucene.search.highlight.SimpleSpanFragmenter;
import org.apache.lucene.store.FSDirectory;

import fun.thereisno.entity.Jar;
import fun.thereisno.entity.PageBean;
import fun.thereisno.util.PropertiesUtil;

public class JarIndex {
	
	private String indexPath = PropertiesUtil.getKey("indexPath");
	
	private IndexWriter writer;
	
	public IndexWriter getWriter(){
		try {
			writer = new IndexWriter(FSDirectory.open(Paths.get(indexPath)), new IndexWriterConfig());
			return writer;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * @param id key
	 * @param name name
	 * @author Administrator
	 */
	public void indexJar(String id, String name){
		getWriter();
		Document doc = new Document();
		doc.add(new StringField("id", id, Store.YES));
		doc.add(new TextField("name", name, Store.YES));
		try {
			writer.addDocument(doc);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				writer.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void updateJar(String id, String name){
		getWriter();
		Document doc = new Document();
		doc.add(new StringField("id", id, Store.YES));
		doc.add(new TextField("name", name, Store.YES));
		try {
			writer.updateDocument(new Term("id", id), doc);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				writer.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void delete(String id){
		getWriter();
		try {
			writer.deleteDocuments(new Term("id", id));
			writer.forceMergeDeletes();
			writer.commit();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				writer.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public List<Jar> search(String name, PageBean pageBean){
		List<Jar> jarList = new ArrayList<Jar>();
		File f = new File(indexPath);
		IndexSearcher searcher = null;
		if(f.list().length > 1){
			try {
				searcher = new IndexSearcher(DirectoryReader.open(FSDirectory.open(Paths.get(indexPath))));
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		Query q = null;
		try {
			q = new QueryParser("name", new StandardAnalyzer()).parse(name);
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		if(pageBean != null){
			if(f.list().length > 1){
				QueryScorer scorer = new QueryScorer(q);
				Fragmenter frag = new SimpleSpanFragmenter(scorer);
				Formatter formatter = new SimpleHTMLFormatter("<b><span style='color:red'>", "</span></b>");
				Highlighter lighter = new Highlighter(formatter, scorer);
				lighter.setTextFragmenter(frag);
				try {
					TopDocs tops = searcher.search(q, 100);
					long total = tops.totalHits > 100 ? 100 : tops.totalHits;
					ScoreDoc sd = null;
					if(pageBean.getStart() > 0){
						sd = tops.scoreDocs[pageBean.getStart() - 1];
					}
					tops = searcher.searchAfter(sd, q, pageBean.getRows());
					Jar jar = null;
					for(ScoreDoc doc : tops.scoreDocs){
						jar = new Jar();
						Document docu = searcher.doc(doc.doc);
						String longName = docu.get("name");
						jar.setId(docu.get("id"));
						jar.setName(lighter.getBestFragment(new StandardAnalyzer(), "name", longName));
						jarList.add(jar);
					}
					Jar info = new Jar();
					info.setJarSize((int) total);
					jarList.add(info);
					return jarList;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvalidTokenOffsetsException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			return null;
		}else{
			if(f.listFiles().length > 1){
				try {
					TopDocs tops = searcher.search(q, 16);
					Jar jar = null;
					for(ScoreDoc doc : tops.scoreDocs){
						Document docu = searcher.doc(doc.doc);
						jar = new Jar();
						jar.setId(docu.get("id"));
						jar.setName(docu.get("name"));
						jarList.add(jar);
					}
					return jarList;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			return null;
		}
	}
}

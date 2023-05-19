package vo;

public class BoardFile {
	private int BoardFileNo;
	private int BoardNo;
	private String originFilename;
	private String saveFilename;
	private String path;
	private String type;
	private String createdate;
	
	public int getBoardFileNo() {
		return BoardFileNo;
	}
	public void setBoardFileNo(int boardFileNo) {
		BoardFileNo = boardFileNo;
	}
	public int getBoardNo() {
		return BoardNo;
	}
	public void setBoardNo(int boardNo) {
		BoardNo = boardNo;
	}
	public String getOriginFilename() {
		return originFilename;
	}
	public void setOriginFilename(String originFilename) {
		this.originFilename = originFilename;
	}
	public String getSaveFilename() {
		return saveFilename;
	}
	public void setSaveFilename(String saveFilename) {
		this.saveFilename = saveFilename;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
}

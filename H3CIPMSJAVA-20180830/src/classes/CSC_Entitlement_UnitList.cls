public class CSC_Entitlement_UnitList {
	public String SerialNumber;
	public List<CSC_Entitlement_ProductList> PnList;
	
	public CSC_Entitlement_UnitList() {
        PnList = new List<CSC_Entitlement_ProductList>();
    }
}
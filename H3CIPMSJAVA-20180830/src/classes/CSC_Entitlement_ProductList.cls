public class CSC_Entitlement_ProductList {

    public String productID { get; set; }
	public String productDescription { get; set; }
	public String productLineCode { get; set; }
	public String productLineDescription { get; set; }
	public String endOfSupportLife { get; set; }
	public String functionalLocation { get; set; }
	public CSC_Entitlement_ManufacturerComplex manufacturerComplex { get; set; }

	public CSC_Entitlement_ProductList(){

		manufacturerComplex = new CSC_Entitlement_ManufacturerComplex();
	}
}
solidity pragma 0.8.0;
contract ProductSales{

    struct Product{
    uint ID;
    string name;
    uint inventory;
    uint price;
    }
    struct Buyer{
        string name;
        string email;
        string mailingAddress;
        uint totalOrders;
        bool isActive;
    }
    struct Order{
        uint orderID;
        uint productID;
        uint quantity;
        address buyer;
    }
    address public owner;
    mapping(address => Buyer) public buyers;
    mapping(uint => Product) public products;
    mapping(uint => Order) public orders;

    uint public numProducts;
    uint public numBuyers;
    uint public numOrders;

    event NewProduct(uint _ID, string _name, uint _inventory, uint _price);
    event NewBuyer(string _name, string _email, string _mailingAddress);
    event NewOrder(uint _OrderID, uint _ID,uint _quantity, address _from);

    modifier onlyOwner(){
        require(msg.sender != owner);
        {
            revert();
        }
        _
    }

    constructor(){
        owner = msg.sender;
        numBuyers = 0;
        numProducts = 0;
    }

    function addProduct(uint _ID, string _name, uint _inventory, uint _price) onlyOwner{
        Product p = products[_ID];
        p.ID = _ID;
        p.name = _name;
        p.inventory = _inventory;
        p.price = _price;
        numProducts++;
        NewProduct(_ID, _name, _inventory, _price); 
    }

    function updateProduct(uint _ID, string _name, uint _inventory, uint _price){
        products[_ID].name = _name;
        products[_ID].inventory = _inventory;
        products[_ID].price = _price;
    }

    function registerBuyer(string _name,string _email,string _mailingAddress){
        Buyer b = buyers[msg.sender];
        b.name = _name;
        b.email = _email;
        b.mailingAddress = _mailingAddress;
        b.totalOrders = 0;
        b.isActive = true;
        numBuyers++;
        NewBuyer(_name, _email, _mailingAddress);
    }
    function buyProduct(uint _ID, uint _quantity) returns(uint newOrderID){
        //check if there sufficient inventory of the product
        if(products[_ID].inventory < _quantity){
            revert();
        }
    //check if amount aid is not less than the order amount
    uint orderAmount = products[_ID].price*_quantity;
    if(msg.value<orderAmount){
        revert();
    }
    //check if buyer is registered
    if(buyers[msg.sender].isActive != true){
        revert();
    }
    //update total orders of buyer
    buyers[msg.sender].totalOrders +=1;

    //generate new order ID
    newOrderID = uint(msg.sender) + block.timestamp;

    //create a new order
    Order o = orders[NewOrderID];
    o.orderID = newOrderId;
    o.productID = _ID;
    o.quantity = _quantity;
    o.buyer = msg.sender;

    //update total number of orders
    numOrders++;

    //Update product inventory
    products[_ID].inventory = products[_ID].inventory - 1;

    //refund balance to the buyer 
    if(msg.value > orderAmount){
        uint refundAmount = msg.value - orderAmount;
        if(!msg.sender.send(refundAmount))
         revert();
    }
    NewOrder(newOrderID, _ID, _quantity, msg.sender);
    }
    function withdrawFunds() onlyOwner{
        if(!owner.send(this.send));
        revert();
    }
    function kill() onlyOwner{
        selfdestruct(owner);
    }
}

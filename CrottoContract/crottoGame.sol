pragma solidity^0.4.25;

contract crottoPointInterface{
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


contract crottoGame{
    
    //crotto point token
    address public crottoPointAddr = 0x80406630DA2ECA06E293467f2b757049823Cd361;
    crottoPointInterface crottoPoint = crottoPointInterface(crottoPointAddr);
    
    //setup owner and playable
    address owner;
    address playable;
    bool private playStatus = false;
    bool private playStatusFirst = false;
    bool private stopStatusFirst = false;
    
    //room info
    mapping(uint => mapping(uint => uint)) roomSizeByType;
    mapping(uint => mapping(uint => uint))  public numPlayerInRoomByType;
    mapping(uint => mapping(uint => mapping(uint => address))) public playerInRoomByType;
    mapping(uint => mapping(uint => address)) winnnerInRoomByType;
    mapping(uint => mapping(uint => uint)) roomStateByType;
    
    //configuration
    mapping(uint => uint) maximumPayByType;
    mapping(uint => uint) prizeByType;
    mapping(uint => uint) maxPointUseByType;
    mapping(uint => uint) balanceRoomByType;
    
    mapping(uint => uint) roomInRangeByType;
    mapping(uint => uint) indexReadyRoomInRangeByType;
    mapping(uint => uint) lengthRoomByType;
    mapping(uint => uint) minLengthByType;
    mapping(uint => uint) pointerRoomByType;
    
    uint faucet = 0;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function() public payable{
        require(crottoPoint.balanceOf(msg.sender) >= 2000000000);
    }
    
    event join(uint roomNo);
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyPlayable(){
        require(msg.sender == playable);
        _;
    }
    
    function setPlayable() public {
        require(playable == address(0));
        playable = msg.sender;
    }
    
    function setGameStartFirst() public onlyPlayable{
        require(playStatusFirst != true);
        playStatusFirst = true;
    }
    
    function setGameStopFirst() public onlyPlayable{
        require(stopStatusFirst != true);
        stopStatusFirst = true;
    }
    
    function setGameStart() public onlyOwner{
        require(playStatusFirst == true);
        playStatus = true;
    }
    
    function setGameStop() public onlyOwner{
        require(stopStatusFirst == true);
        playStatus = false;
    }
    
    function setDefaultGame() public onlyPlayable{
        roomInRangeByType[1] = 5;
        maximumPayByType[1] = 0.003 ether;
    }
    
    function initReadyRoom(uint roomType) internal {
        if(lengthRoomByType[roomType] == uint(0)){
            lengthRoomByType[roomType] = 0;
            pointerRoomByType[roomType] = 0;
        }
        
        for(uint i = lengthRoomByType[roomType]; i<= roomInRangeByType[roomType]; i++){
            pointerRoomByType[roomType]++;
            indexReadyRoomInRangeByType[i] = pointerRoomByType[roomType];
        }
    }
    
    function getRandom(uint roomType) internal view returns (uint256) {
        
        if(lengthRoomByType[roomType] <= minLengthByType[roomType]){
            initReadyRoom(roomType);
        }
        
        uint256 rand = uint256(uint256(keccak256(abi.encodePacked(msg.value, block.number, msg.sender))) % roomInRangeByType[roomType]) + 1;
        return rand;
    }
    
    function joinGame(uint roomType) public {
        require(msg.value >= maximumPayByType[roomType]);
        
        uint indexRoom = getRandom(roomType);
        uint256 roomNo = indexReadyRoomInRangeByType[indexRoom];
        
        if(numPlayerInRoomByType[roomType][roomNo] == uint(0)){
            numPlayerInRoomByType[roomType][roomNo] = 0;
            roomStateByType[roomType][roomNo] = 1;
        }
        
        numPlayerInRoomByType[roomType][roomNo] += 1;
        playerInRoomByType[roomType][roomNo][numPlayerInRoomByType[roomType][roomNo]] = msg.sender;
        
        if(numPlayerInRoomByType[roomType][roomNo] == 10){
            roomStateByType[roomType][roomNo] = 2;
            deleteRoom(roomType, indexRoom);
        }
        emit join(roomNo);
    }
    
    function getPrize(uint roomType, uint roomNo) public returns(bool){
        
    }
    
    function getPoint(uint roomType, uint roomNo) public {
        
    }
    
    //delete room
    function deleteRoom(uint roomType, uint index){
        if(lengthRoomByType[roomType] == 0) return;
        
        for(uint i = index;i<=lengthRoomByType[roomType];i++){
            indexReadyRoomInRangeByType[i] = indexReadyRoomInRangeByType[i+1];
        }
  
        lengthRoomByType[roomType]--;
    }
    
}
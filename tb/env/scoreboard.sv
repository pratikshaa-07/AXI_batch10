class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(seq_item) wrt_fifo;   // from write-fifo monitor
  uvm_tlm_analysis_fifo #(seq_item) rd_fifo;   // from read-fifo monitor

  //assosiative array for storing the wrt packet
  bit[31:0]array[seq_item];

  //assosiative array for wrt response 24 bits packet with address as index
  bit[23:0]wrt_rsp[bit[31:0]];

  //seq item
  seq_item wrt,rd;

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wrt_fifo = new("wrt_fifo", this);
    rd_fifo = new("rd_mon_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
        // seq_item wrt,rd;
        wrt = seq_item::type_id::create("wrt");
        rd  = seq_item::type_id::create("rd");
      fork
          begin
              wrt_fifo.get(wrt);
              wrt_task();
          end
          begin
              rd_fifo.get(rd);
              rd_task();
          end
     join
  end
  
  endtask

  task wrt_task();
      bit[23:0]temp;
      if(wrt.wr_en==0)
      begin
          `uvm_info("SCB","wr_en is zero",UVM_LOW)
      end
      else
      begin
        `uvm_info("SCB","Inside the wr_en=1 ",UVM_LOW)
        `uvm_info("SCB",$sformatf("got packet = %0h",wrt.wr_data),UVM_LOW)
        `uvm_info("SCB",$sformatf("got address = %0h",wrt.wr_data[115:84]),UVM_LOW)
        `uvm_info("SCB",$sformatf("got id = %0d",wrt.wr_data[119:116]),UVM_LOW)
        temp='b0;
        temp[7:0]=8'b10101010;
        temp[23:16]=8'b01010011;
        temp[11:8]=wrt.wr_data[119:116];
        temp[15:12]=4'b0;
        
      end
  endtask

  task rd_task();
  endtask
endclass

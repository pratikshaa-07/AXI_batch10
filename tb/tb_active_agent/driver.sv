class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

    bit stream[$];

  virtual inf.DRV vif;

  function new(string name="", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Virtual Interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat (3) @(vif.drv_cb);

    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    vif.drv_cb.wr_en<=req.wr_en;
    vif.drv_cb.rd_en<=req.rd_en;

    fork
      if(req.wr_en)
      begin
        //making a stream
        get_stream(req);
        vif.drv_cb.wr_en<=req.wr_en;
        if(req.wr_en==1)
          write_task();
        @(vif.drv_cb);
      end

     if(req.rd_en)
      begin
        `uvm_info("DRV","rd_en is high",UVM_LOW)
        @(vif.drv_cb);
      end
      
    join

    if(req.rd_en == 0 && req.wr_en == 0)
      begin
        `uvm_info("DRV","Both rd_en and wr_en signals are low",UVM_LOW)
        @(vif.drv_cb);
      end
  endtask

  function void get_stream(seq_item tx);
    bit temp[$];
    stream = {};

    temp = {>>{tx.sop}};      stream = {stream,temp};
    //`uvm_info("DRV",$sformatf("sop = %0b",tx.sop),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.txn_id}};   stream = {stream,temp};
    `uvm_info("DRV",$sformatf("txn_id = %0d",tx.txn_id),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.addr}};     stream = {stream,temp};
    `uvm_info("DRV",$sformatf("addr = %0h",tx.addr),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.len}};      stream = {stream,temp};
    `uvm_info("DRV",$sformatf("len = %0d",tx.len),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.size}};     stream = {stream,temp};
    `uvm_info("DRV",$sformatf("size = %0d",tx.size),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    `uvm_info("DRV",$sformatf("data.size()=%0d",tx.data.size()),UVM_LOW)

    temp = {>>{tx.burst}};    stream = {stream,temp};
   `uvm_info("DRV",$sformatf("burst = %0d",tx.burst),UVM_LOW)
   //  `uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.lock}};     stream = {stream,temp};
    `uvm_info("DRV",$sformatf("lock = %0d",tx.lock),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.cache}};    stream = {stream,temp};
    `uvm_info("DRV",$sformatf("cache = %0b",tx.cache),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.prot}};     stream = {stream,temp};
    `uvm_info("DRV",$sformatf("prot = %0b",tx.prot),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    temp = {>>{tx.strobe}};      stream = {stream,temp};
    `uvm_info("DRV",$sformatf("strobe = %0b",tx.strobe),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    
    
    foreach (tx.data[i])
    begin
      temp = {>>{tx.data[i]}};
      stream = {stream,temp};
      //`uvm_info("DRV",$sformatf("data = %0b",tx.data[i]),UVM_LOW)
     // `uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
    end

    temp = {>>{tx.eop}}; stream = {stream,temp};
    //`uvm_info("DRV",$sformatf("eop = %0b",tx.eop),UVM_LOW)
    //`uvm_info("DRV",$sformatf("stream = %0p",stream),UVM_LOW)
  endfunction

  task write_task();
    int total_bits;
    int num_beats;
    bit [127:0] beat;
    int idx;
    
    total_bits = stream.size();
    num_beats  = (total_bits + 127) / 128;
    idx = 0;

  for (int b = 0; b < num_beats; b++) 
    begin
    // while (vif.drv_cb.full == 1'b1)
    //   @(vif.drv_cb);
      beat = '0;
      for (int k = 127; k >= 0; k--) 
        begin
          if (idx < total_bits)
            beat[k] = stream[idx];
          idx++;
        end
    vif.drv_cb.wr_data <= beat;
    `uvm_info("DRV",$sformatf("Beat =%0d ",beat),UVM_LOW)
    @(vif.drv_cb);
  end
  vif.drv_cb.wr_en <= 1'b0;

endtask


endclass

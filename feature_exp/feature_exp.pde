final String file_name = "../feature2.dat";
final String file_name2 = "../feature3.dat";
final int data_height = 500;
final int data_width = 500;
final int data_depth = 100;

class Feature{
  public int ID;
  public PVector centerPt = new PVector();
  public ArrayList<PVector> pts = new ArrayList<PVector>();
}

class FeatureGroup{
   HashMap<Integer,Feature> hash = new HashMap<Integer,Feature>();
}
void computeMiniLine(){
  
}
PVector convertIndex2Vec3(int index ){
  PVector p = new PVector();
  p.z = index / (data_width*data_height);
  index = index % (data_width*data_height);
  p.y = index / data_width;
  index = index % data_width;
  p.x = index;
  return p;
}

ArrayList<FeatureGroup> timeData = new ArrayList<FeatureGroup>(); 

FeatureGroup loadFeature( final String file_name ){
  FeatureGroup group = new FeatureGroup();
  HashMap<Integer,Feature> hash = group.hash;
  BufferedReader reader = createReader( file_name );
  int index = 0;
  try{
    int id;
    while( (id = reader.read() ) != -1 ){
      if( id != 0 ){
        Feature pFeature = hash.get(id);
        if( pFeature == null ){
          pFeature = new Feature();
          hash.put( id , pFeature );
        }
        pFeature.pts.add( convertIndex2Vec3(index) );
      }
      index++;
    }
  }catch( IOException e ){
  }
  println( hash.size() );
  for( int i : group.hash.keySet() ){
    Feature featurei = group.hash.get(i);
    PVector calCenter = new PVector(0,0,0);
    for(int j = 0 ; j != featurei.pts.size() ; j++ ){
      calCenter.add( featurei.pts.get(j) );
    }
    calCenter.div( featurei.pts.size() );
    featurei.centerPt = calCenter.get(); 
  }
  return group;
}
void setup(){
  timeData.add( loadFeature(file_name) ); 
  
  timeData.add( loadFeature(file_name2) );
  /*
  data_width = data_height = 500;
  data_depth = 100;
  println( convertIndex2Vec3(0).x + "," + convertIndex2Vec3(0).y + "," + convertIndex2Vec3(0).z);
  println( convertIndex2Vec3(100).x + "," + convertIndex2Vec3(100).y + "," + convertIndex2Vec3(100).z);
  println( convertIndex2Vec3(1000).x + "," + convertIndex2Vec3(1000).y + "," + convertIndex2Vec3(1000).z);
  println( convertIndex2Vec3(24999999).x + "," + convertIndex2Vec3(24999999).y + "," + convertIndex2Vec3(24999999).z);
  */
  
 
  size( 1680 , 1024 );
  background(127);
}

int num = 1;

void draw(){
   background(204);
  float c;
  for( int t = 0 ; t != timeData.size() ; t++){
    FeatureGroup group = timeData.get(t);
  for(int i : group.hash.keySet()  ){
    c = i /( float ) group.hash.size();
    fill( t *255*c , 0 , 255*c );
    rect( group.hash.get(i).centerPt.x , group.hash.get(i).centerPt.y , 10 , 10 );
  }
  }
  // link lines

  
  for( int t = 0 ; t != timeData.size() - 1 ; t++){
    FeatureGroup group = timeData.get(t);
    FeatureGroup group1 = timeData.get(t+1);
    
    
    //connections
  //  for( int num = 1 ; num != numLinks ; num++ ){
       //println("num: " + num );
       int numLinks = max( group.hash.keySet().size() , group1.hash.keySet().size() );
   // println("links: " + numLinks );
  if( group.hash.get(num) != null && group1.hash.get(num) != null ){
      stroke( 255 , 0, 0);    
      line( group.hash.get(num).centerPt.x + 5 , group.hash.get(num).centerPt.y + 5 , group1.hash.get(num).centerPt.x + 5 , group1.hash.get(num).centerPt.y + 5);
      c = num /( float ) group.hash.size();
      fill( 0 , 0 , 255*c );
      rect( group.hash.get(num).centerPt.x , group.hash.get(num).centerPt.y , 10 , 10);
      c = num /( float ) group1.hash.size();
      fill( 255*c , 0 , 255*c );
      rect( group1.hash.get(num).centerPt.x , group1.hash.get(num).centerPt.y , 50 , 50 );
      stroke(0);
      println( group.hash.get(num).centerPt.x +","+ group.hash.get(num).centerPt.y);
      println( group1.hash.get(num).centerPt.x +","+ group1.hash.get(num).centerPt.y);
  }else{ println( "empty"); }
    //}
    println("links: " + numLinks );
    num++;
    println( "num: " + num );
    if( num > numLinks ) num = 0;
    delay(1000);
  }
  
  
}

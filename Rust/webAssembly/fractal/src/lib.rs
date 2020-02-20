mod utils;

use wasm_bindgen::prelude::*;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
pub struct Fractal{
    width:  usize,
    height: usize,
    magnification_error: i32,
    pan_x: f32,
    pan_y: f32,
    accuracy:usize,
    mem: Vec<usize>
}

#[wasm_bindgen]
impl Fractal{
    pub fn new() -> Fractal{
        let width = 1024;
        let height = 1024;
        let mem = (0..width * height).map(|_| 0).collect();
        Fractal {width:width, height:height, magnification_error: 200, pan_x:2., pan_y:2., accuracy: 100, mem:mem}
    }
    pub fn get_height(&self) -> usize{
        self.height
    }
    pub fn get_width(&self) -> usize{
        self.width
    }
    pub fn set_mag(&mut self, v:i32){
        self.magnification_error = v;
    }
    pub fn set_x(&mut self, x:f32){
        self.pan_x = x;
    }
    pub fn set_y(&mut self, y:f32){
        self.pan_y = y;
    }
    pub fn set_acc(&mut self, acc:usize){
        self.accuracy = acc;
    }
    pub fn in_set(&self, x:i32, y:i32) -> usize{
        let x = (x as f32 / self.magnification_error as f32) - self.pan_x;
        let y = (y as f32 / self.magnification_error as f32) - self.pan_y;
        let mut real = x;
        let mut imgn = y;
        for i in 0..self.accuracy{
            let treal = real*real - imgn*imgn + x;
            let timgn = 2.*real*imgn + y;
            real = treal;
            imgn = timgn;
            if real * imgn > 5.{
                return (i as f32 / self.accuracy as f32 * 100.) as usize;
            }
        }
        0
    }
    pub fn set_bytes(&mut self){
        for x in 0..self.width{
            for y in 0..self.height{
                self.mem[x*self.width+y] = self.in_set(x as i32, y as i32);
            }
        }
    }
    pub fn mem(&mut self) -> *const usize{
        self.mem.as_ptr()
    }
}